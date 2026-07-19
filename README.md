# Behavioral-health NPI leads in GitHub Actions

Download organizations that received a behavioral-health NPI in the latest CMS weekly file. The free preview needs no account, token, or payment and writes 15 current records as clean JSON inside your workflow.

When the sample fits, choose the delivery path that matches the job:

- [Buy the current national CSV for **$19 once**](https://buy.stripe.com/6oUdR29Ue7rDg80fLd6oo0i?client_reference_id=github_action_readme&utm_source=github&utm_medium=repository&utm_campaign=practice_radar_edition) for private browser delivery with no Apify account, subscription, or renewal. The purchased edition does not update.
- Run [New Behavioral Health Practices Weekly](https://apify.com/actablesite/new-behavioral-health-practices-actor) in your own Apify account when the feed belongs inside an automated workflow. It charges one **$9 event** plus small platform usage and refuses to run without both a token and an explicit $9.25 total-charge cap.

## Quick start: free preview

```yaml
name: Preview new behavioral-health practices

on:
  workflow_dispatch:

jobs:
  preview:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - id: practices
        uses: unitedideas/behavioral-health-practice-leads-action@v1
        with:
          states: CA,TX
      - uses: actions/upload-artifact@v4
        with:
          name: behavioral-health-practices
          path: ${{ steps.practices.outputs.output-file }}
```

The preview downloads the current, versioned 15-row sample from the public [Practice Radar data repository](https://github.com/unitedideas/practice-radar-data). It does not create an Apify run or incur a charge. The workflow summary reports the delivered count, CMS weekly period, state filter, source, and data limitation before the optional full-edition handoff.

## Automate the full weekly edition

Create an Apify API token in your own account, store it as the repository secret `APIFY_TOKEN`, set `preview: false`, and explicitly raise the cap:

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

If you only need a downloadable national CSV for the current measured week, the [$19 one-time edition](https://buy.stripe.com/6oUdR29Ue7rDg80fLd6oo0i?client_reference_id=github_action_readme&utm_source=github&utm_medium=repository&utm_campaign=practice_radar_edition) avoids the Apify setup. It uses private browser delivery and never renews.

## Inputs

| Input | Default | Meaning |
| --- | --- | --- |
| `apify-token` | empty | Your Apify API token, required only for a full edition and supplied through GitHub Secrets. |
| `states` | empty | Optional comma-separated two-letter state or territory codes. |
| `preview` | `true` | Return the deterministic 15-row preview. |
| `max-total-charge-usd` | `0.10` | Hard cap for the entire run. Full editions require at least `9.25`. |
| `output-file` | `behavioral-health-practices.json` | JSON destination inside the workflow workspace. |

The action returns `record-count` and `output-file` outputs and writes a source-linked GitHub workflow summary. Uploading or committing the file is an explicit workflow choice; this action does neither automatically.

## What the data means

The Actor selects newly enumerated Type 2 organizations from the latest official CMS NPPES weekly V2 archive, matches eight disclosed behavioral-health taxonomy codes, removes deactivated rows, and deduplicates organization/city/state combinations.

An NPI does not prove licensure, credentialing, active operation, independence, service availability, demand, or buying intent. NPPES data can be incomplete, self-reported, stale, or shared across related organizations. Verify every record before a consequential decision or contact.

## Security and operating boundary

- The free preview reads only the public, versioned Practice Radar sample and needs no credential.
- For a full edition, use the least-privilege Apify token available to your account and store it only in GitHub Secrets.
- GitHub does not provide repository secrets to workflows triggered from untrusted forks by default.
- Every call has a caller-selected total charge cap and a five-minute timeout.
- The action does not send email, contact organizations, enrich public records, or transmit the dataset anywhere except the public preview source, your selected Apify account for a full edition, and the workflow runner.

## License

MIT
