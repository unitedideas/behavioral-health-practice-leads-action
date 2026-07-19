#!/usr/bin/env bash
set -euo pipefail

actor_id="actablesite~new-behavioral-health-practices-actor"
public_preview_url="https://raw.githubusercontent.com/unitedideas/practice-radar-data/main/public/sample.json"
direct_edition_checkout_url="https://buy.stripe.com/6oUdR29Ue7rDg80fLd6oo0i?client_reference_id=github_action_summary&utm_source=github&utm_medium=workflow_summary&utm_campaign=practice_radar_edition"
preview="${PREVIEW:-true}"
states="${STATES:-}"
max_charge="${MAX_TOTAL_CHARGE_USD:-0.10}"
output_file="${OUTPUT_FILE:-behavioral-health-practices.json}"

if [[ "$preview" != "true" && "$preview" != "false" ]]; then
  echo "preview must be true or false." >&2
  exit 2
fi
if ! [[ "$max_charge" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "max-total-charge-usd must be a non-negative number." >&2
  exit 2
fi
if [[ "$preview" == "false" ]] && ! awk -v value="$max_charge" 'BEGIN { exit !(value >= 9.25) }'; then
  echo "A full edition needs max-total-charge-usd of at least 9.25 to cover the fixed \$9 event and bounded platform usage." >&2
  exit 2
fi
if [[ "$preview" == "false" && -z "${APIFY_TOKEN:-}" ]]; then
  echo "APIFY_TOKEN is required for a full edition. Store it as a GitHub Actions secret." >&2
  exit 2
fi
if [[ "$output_file" == *$'\n'* || "$output_file" == *$'\r'* || "$output_file" == *'`'* || -z "$output_file" ]]; then
  echo "output-file must be a non-empty single-line path without backticks." >&2
  exit 2
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
input_file="$tmp_dir/input.json"
response_file="$tmp_dir/response.json"
states_json="$(jq -Rn --arg states "$states" '$states | split(",") | map(gsub("^[[:space:]]+|[[:space:]]+$"; "") | ascii_upcase | select(length > 0))')"
if ! jq -e 'all(.[]; test("^[A-Z]{2}$"))' <<<"$states_json" >/dev/null; then
  echo "states must contain only comma-separated two-letter state or territory codes." >&2
  exit 2
fi

if [[ "$preview" == "true" ]]; then
  http_status="$({
    curl --silent --show-error --location \
      --output "$response_file" \
      --write-out '%{http_code}' \
      "$public_preview_url"
  } 2>"$tmp_dir/curl-error")" || {
    echo "The public preview request failed before returning an HTTP response." >&2
    sed -n '1,3p' "$tmp_dir/curl-error" >&2
    exit 1
  }
else
  jq -n \
    --argjson states "$states_json" \
    '{ preview: false, states: $states }' > "$input_file"

  endpoint="https://api.apify.com/v2/acts/${actor_id}/run-sync-get-dataset-items"
  query="timeout=300&memory=512&maxTotalChargeUsd=${max_charge}&format=json&clean=true"
  http_status="$({
    curl --silent --show-error --location \
      --output "$response_file" \
      --write-out '%{http_code}' \
      --request POST \
      --header "Authorization: Bearer ${APIFY_TOKEN}" \
      --header 'Content-Type: application/json' \
      --data-binary "@${input_file}" \
      "${endpoint}?${query}"
  } 2>"$tmp_dir/curl-error")" || {
    echo "The Apify request failed before returning an HTTP response." >&2
    sed -n '1,3p' "$tmp_dir/curl-error" >&2
    exit 1
  }
fi

if [[ ! "$http_status" =~ ^2[0-9][0-9]$ ]]; then
  error_message="$(jq -r '.error.message // .message // "Data request failed"' "$response_file" 2>/dev/null || printf 'Data request failed')"
  printf 'Data request returned HTTP %s: %s\n' "$http_status" "$error_message" >&2
  exit 1
fi
if [[ "$preview" == "true" ]]; then
  if ! jq -e '
    .receipt.schema_version == 1
    and (.receipt.period.start | type == "string" and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}$"))
    and (.receipt.period.end | type == "string" and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}$"))
    and (.records | type == "array")
  ' "$response_file" >/dev/null; then
    echo "The public preview did not match the versioned Practice Radar contract." >&2
    exit 1
  fi
  preview_period_start="$(jq -r '.receipt.period.start' "$response_file")"
  preview_period_end="$(jq -r '.receipt.period.end' "$response_file")"
  jq --argjson states "$states_json" \
    'if ($states | length) == 0 then .records else [.records[] | select(.state as $state | ($states | index($state)) != null)] end' \
    "$response_file" > "$tmp_dir/filtered.json"
  mv "$tmp_dir/filtered.json" "$response_file"
elif ! jq -e 'type == "array"' "$response_file" >/dev/null; then
  echo "Apify returned an invalid dataset response; no output file was published." >&2
  exit 1
fi

mkdir -p "$(dirname "$output_file")"
mv "$response_file" "$output_file"
record_count="$(jq 'length' "$output_file")"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  printf 'record-count=%s\n' "$record_count" >> "$GITHUB_OUTPUT"
  printf 'output-file=%s\n' "$output_file" >> "$GITHUB_OUTPUT"
fi
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    if [[ "$preview" == "true" ]]; then
      printf '## Behavioral-health NPI lead preview\n\n'
      printf '**%s current sample records** were written to `%s`.\n\n' "$record_count" "$output_file"
      printf -- '- CMS NPPES weekly period: **%s through %s**\n' "$preview_period_start" "$preview_period_end"
      if [[ "$(jq 'length' <<<"$states_json")" -gt 0 ]]; then
        printf -- '- State filter: **%s**\n' "$(jq -r 'join(", ")' <<<"$states_json")"
      else
        printf -- '- State filter: **all states represented in the public sample**\n'
      fi
      printf -- '- Source: [CMS NPPES downloadable files](https://download.cms.gov/nppes/NPI_Files.html)\n\n'
      printf 'An NPI does not prove licensure, credentialing, active operation, service availability, demand, or buying intent. Verify every record before consequential use.\n\n'
      printf '### Need every current row?\n\n'
      printf -- '- [Buy the current national CSV for $19 once](%s) for private browser delivery with no Apify account, subscription, or renewal. The purchased edition does not update.\n' "$direct_edition_checkout_url"
      printf -- '- [Automate the full weekly edition on Apify](https://apify.com/actablesite/new-behavioral-health-practices-actor) for one $9 event plus bounded buyer-paid platform usage.\n'
    else
      printf '## Behavioral-health NPI lead export\n\n'
      printf '**%s full-edition records** were written to `%s` through the caller-funded, cost-capped Apify run.\n\n' "$record_count" "$output_file"
      printf 'An NPI does not prove licensure, credentialing, active operation, service availability, demand, or buying intent. Verify every record before consequential use.\n'
    fi
  } >> "$GITHUB_STEP_SUMMARY"
fi
printf 'Wrote %s records to %s.\n' "$record_count" "$output_file"
