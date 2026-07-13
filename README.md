# New behavioral-health practices in GitHub Actions

Export organizations that received a behavioral-health NPI in the latest CMS weekly file. The action runs [New Behavioral Health Practices Weekly](https://apify.com/actablesite/new-behavioral-health-practices-actor), waits for the dataset, and writes clean JSON inside your workflow.

The default is a deterministic 15-row preview with a $0.10 hard run cap. A full edition charges one $9 Apify event plus small platform usage and requires an explicit higher cap.

## Quick start: free preview

```yaml
name: Preview new behavioral-health practices

on:
  workflow_dispatch:

jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - id: practices
        uses: unitedideas/behavioral-health-practice-leads-action@v1
        with:
          apify-token: ${{ secrets.APIFY_TOKEN }}
          states: CA,TX
      - uses: actions/upload-artifact@v4
        with:
          name: behavioral-health-practices
          path: ${{ steps.practices.outputs.output-file }}
```

Create an Apify API token in your own account and store it as the repository secret `APIFY_TOKEN`. The action sends it only in the Apify authorization header and never prints it.

## Full weekly edition

Set `preview: false` and explicitly raise the cap:

```yaml
      - id: practices
        uses: unitedideas/behavioral-health-practice-leads-action@v1
        with:
          apify-token: ${{ secrets.APIFY_TOKEN }}
          preview: false
          states: CA,TX,FL
          max-total-charge-usd: "9.25"
```

The full edition event is charged once only after the Actor downloads, parses, and validates the current CMS archive. The cap covers the fixed $9 event and bounded Apify platform usage. If the charge is not authorized, the Actor does not deliver full records.

## Inputs

| Input | Default | Meaning |
| --- | --- | --- |
| `apify-token` | required | Your Apify API token, supplied through GitHub Secrets. |
| `states` | empty | Optional comma-separated two-letter state or territory codes. |
| `preview` | `true` | Return the deterministic 15-row preview. |
| `max-total-charge-usd` | `0.10` | Hard cap for the entire run. Full editions require at least `9.25`. |
| `output-file` | `behavioral-health-practices.json` | JSON destination inside the workflow workspace. |

The action returns `record-count` and `output-file` outputs. Uploading or committing the file is an explicit workflow choice; this action does neither automatically.

## What the data means

The Actor selects newly enumerated Type 2 organizations from the latest official CMS NPPES weekly V2 archive, matches eight disclosed behavioral-health taxonomy codes, removes deactivated rows, and deduplicates organization/city/state combinations.

An NPI does not prove licensure, credentialing, active operation, independence, service availability, demand, or buying intent. NPPES data can be incomplete, self-reported, stale, or shared across related organizations. Verify every record before a consequential decision or contact.

## Security and operating boundary

- Use the least-privilege Apify token available to your account and store it only in GitHub Secrets.
- GitHub does not provide repository secrets to workflows triggered from untrusted forks by default.
- Every call has a caller-selected total charge cap and a five-minute timeout.
- The action does not send email, contact organizations, enrich public records, or transmit the dataset anywhere except your selected Apify account and workflow runner.

## License

MIT
