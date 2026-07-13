import assert from "node:assert/strict";
import { mkdtemp, mkdir, readFile, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { spawn } from "node:child_process";
import test from "node:test";

const root = new URL("../", import.meta.url).pathname;
const script = path.join(root, "scripts/run-actor.sh");

async function fixture() {
  const directory = await mkdtemp(path.join(os.tmpdir(), "practice-action-"));
  const bin = path.join(directory, "bin");
  await mkdir(bin);
  const curl = path.join(bin, "curl");
  await writeFile(curl, `#!/usr/bin/env bash
set -euo pipefail
output=""
input=""
while (($#)); do
  case "$1" in
    --output) output="$2"; shift 2 ;;
    --data-binary) input="\${2#@}"; shift 2 ;;
    *) shift ;;
  esac
done
cp "$input" "$CAPTURE_INPUT"
printf '%s' "$FAKE_CURL_BODY" > "$output"
printf '%s' "$FAKE_CURL_STATUS"
`, { mode: 0o755 });
  return { directory, bin };
}

function run(env) {
  return new Promise((resolve) => {
    const child = spawn("bash", [script], { env });
    let stdout = "";
    let stderr = "";
    child.stdout.on("data", (chunk) => { stdout += chunk; });
    child.stderr.on("data", (chunk) => { stderr += chunk; });
    child.on("close", (code) => resolve({ code, stdout, stderr }));
  });
}

test("preview runs normalize state filters and publish action outputs", async () => {
  const { directory, bin } = await fixture();
  const output = path.join(directory, "result.json");
  const capture = path.join(directory, "input.json");
  const githubOutput = path.join(directory, "github-output.txt");
  const result = await run({
    ...process.env,
    PATH: `${bin}:${process.env.PATH}`,
    APIFY_TOKEN: "test-fixture-token",
    PREVIEW: "true",
    STATES: " ca, TX ",
    MAX_TOTAL_CHARGE_USD: "0.10",
    OUTPUT_FILE: output,
    CAPTURE_INPUT: capture,
    FAKE_CURL_BODY: JSON.stringify([{ npi: "123" }, { npi: "456" }]),
    FAKE_CURL_STATUS: "200",
    GITHUB_OUTPUT: githubOutput,
  });
  assert.equal(result.code, 0, result.stderr);
  assert.deepEqual(JSON.parse(await readFile(capture, "utf8")), { preview: true, states: ["CA", "TX"] });
  assert.equal(JSON.parse(await readFile(output, "utf8")).length, 2);
  assert.match(await readFile(githubOutput, "utf8"), /record-count=2/);
});

test("full runs fail closed below the disclosed charge cap", async () => {
  const { bin } = await fixture();
  const result = await run({
    ...process.env,
    PATH: `${bin}:${process.env.PATH}`,
    APIFY_TOKEN: "test-fixture-token",
    PREVIEW: "false",
    MAX_TOTAL_CHARGE_USD: "9.00",
    CAPTURE_INPUT: "/tmp/unused",
    FAKE_CURL_BODY: "[]",
    FAKE_CURL_STATUS: "200",
  });
  assert.equal(result.code, 2);
  assert.match(result.stderr, /at least 9\.25/);
});

test("HTTP failures do not publish a dataset", async () => {
  const { directory, bin } = await fixture();
  const output = path.join(directory, "result.json");
  const result = await run({
    ...process.env,
    PATH: `${bin}:${process.env.PATH}`,
    APIFY_TOKEN: "test-fixture-token",
    PREVIEW: "true",
    MAX_TOTAL_CHARGE_USD: "0.10",
    OUTPUT_FILE: output,
    CAPTURE_INPUT: path.join(directory, "input.json"),
    FAKE_CURL_BODY: JSON.stringify({ error: { message: "fixture failure" } }),
    FAKE_CURL_STATUS: "402",
  });
  assert.equal(result.code, 1);
  assert.match(result.stderr, /HTTP 402: fixture failure/);
});
