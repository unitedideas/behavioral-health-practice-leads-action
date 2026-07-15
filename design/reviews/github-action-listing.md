# GitHub Marketplace and Action repository design review

Reviewed: 2026-07-14
Release source revision: `0af10ff42e3f51f6ab8b8a34dc73b4c635c50c3b`
Verification workflow revision: `dc85c163fe63bb3c1bca6f590e674c4ba590f059`
Surfaces: <https://github.com/marketplace/actions/new-behavioral-health-practices-weekly>, <https://github.com/unitedideas/behavioral-health-practice-leads-action>, and <https://github.com/unitedideas/behavioral-health-practice-leads-action/actions/runs/29379116988>

## Conversion contract

- Category: developer-tool and lead-generation Action repository.
- Audience: healthcare data teams, billing and credentialing vendors, territory planners, and developers who already automate exports in GitHub Actions.
- Primary conversion: copy and run the no-token preview workflow, inspect the source-linked run summary, then graduate to a buyer-funded, cost-capped $9 Apify full edition when the current sample is useful.
- Conversion-quality metric: non-owner unique repository cloners and Action workflow executions that precede an external paid `weekly-edition` event and successful dataset delivery.

## Evidence and judgment

- Measured evidence: Marketplace release `v1.0.3` is public and floating tag `v1` resolves to the reviewed release source; hosted test run `29379040030` passed with zero annotations; production-preview run `29379116988` invoked the public `v1` tag without a secret, delivered three CA/TX records, and rendered the new workflow summary; GitHub Marketplace returns the listing for both `new behavioral health practices` and `behavioral health npi`; public code search reports zero non-owner Action usages at review time.
- Standards: the first README paragraph names the current weekly event and says the preview needs no account, token, or payment. The next paragraph discloses the full-edition price, buyer-funded Apify boundary, and explicit total-charge cap before setup detail.
- Observed pattern: Action buyers scan repository description, release activity, copyable workflow, secret requirements, outputs, and failure/cost controls before adoption.
- Hypothesis: an exact weekly healthcare-data job with a no-account preview will attract more qualified developer intent than a generic Actor API example or a preview that first requires a third-party secret.

## Rendered QA

- Desktop: `design/renders/github-action-desktop.png` at 1440 x 1000.
- Mobile: `design/renders/github-action-mobile.png` at 390 x 844 after viewport reload.
- Marketplace desktop: `design/renders/github-marketplace-desktop.png` at 1440 x 1000.
- Marketplace mobile: `design/renders/github-marketplace-mobile.png` at 390 x 844 after viewport reload.
- Workflow summary desktop: `design/renders/github-workflow-summary-desktop.png` at 1440 x 1000.
- Workflow summary mobile: `design/renders/github-workflow-summary-mobile.png` at 390 x 844 after viewport reload.
- Desktop exposes the repository job, latest release, Marketplace handoff, source tree, and the no-token preview boundary in the first screen. The full-edition $9 boundary begins in the same viewport.
- Mobile keeps the repository description, free-preview statement, Apify destination, and Marketplace handoff readable, but GitHub places the file table ahead of the README. This is controlled by GitHub rather than repository CSS.
- The Marketplace desktop first screen exposes the exact job, no-account preview, full-edition price, latest version, categories, and copyable workflow. The Marketplace mobile first screen exposes the listing title, latest version, primary action, exact job, and complete no-token preview statement before normal scrolling.
- The desktop run summary shows success, delivered count, CMS period, state filter, authoritative source, limitation, and paid handoff in one viewport. The 390 x 844 mobile first screen shows successful fulfillment, the summary heading, and delivered count; provenance, limitations, and the secondary paid handoff remain immediately below in normal document flow.
- Copy, price, secret handling, cost cap, data limitations, and explicit non-outreach boundary are consistent across the repository metadata and README.

## Findings

- **Closed — high:** release `v1.0.3` and floating tag `v1` deliver a real no-token preview with a source-linked conversion summary; the live listing identifies the release as latest and remains discoverable for the buyer query.
- **Closed — high:** weekly and manual production-preview verification now invokes the public release without a secret and fails if the filtered JSON output is missing, empty, malformed, or contains an unexpected state.
- **Closed — medium:** the public repository description now names the no-token preview, $9 event, and buyer-paid platform usage, preserving the decision path above the mobile file table.
- **Open — low:** GitHub's mobile file table remains ahead of the README, so the copyable workflow is below the first screen.
- **Open — low:** GitHub's Marketplace mobile layout places the full $9 sentence just below the initial 390 x 844 viewport. The headline, exact data job, latest version, and primary action remain visible before scrolling; GitHub controls this layout.

Any source, metadata, tag, release, or Marketplace-state change after the revision above invalidates this review.
