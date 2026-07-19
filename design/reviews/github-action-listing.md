# GitHub Marketplace and Action repository design review

Reviewed: 2026-07-19
Release source revision: `3e4e1f9858987dc12e1d669b25295a847d056a3f`
Verification workflow revision: `3e4e1f9858987dc12e1d669b25295a847d056a3f`
Public repository metadata verified: `2026-07-19`
Surfaces: <https://github.com/marketplace/actions/new-behavioral-health-practices-weekly>, <https://github.com/unitedideas/behavioral-health-practice-leads-action>, and <https://github.com/unitedideas/behavioral-health-practice-leads-action/actions/runs/29681555582>

## Conversion contract

- Category: developer-tool and lead-generation Action repository.
- Audience: healthcare data teams, billing and credentialing vendors, territory planners, and developers who already automate exports in GitHub Actions.
- Primary conversion: copy and run the no-token preview, inspect the source-linked run summary, then choose either a $19 one-time current CSV with private browser fulfillment or a buyer-funded, cost-capped $9 Apify event for automation.
- Conversion-quality metric: a source-attributed non-owner paid order followed by successful delivery, with no failed fulfillment, refund, or support burden.

## Evidence and judgment

- Measured evidence: Marketplace release `v1.0.4` is public and floating tag `v1` resolves to the reviewed release source; hosted test run `29681537672` passed; production-preview run `29681555582` invoked the public `v1` tag without a secret, delivered three current CA/TX records, and rendered both paid delivery choices; the live repository and Marketplace listing expose the $19 direct option and the $9 automation option without horizontal overflow at the reviewed sizes.
- Standards: the first README paragraph names the current weekly event and says the preview needs no account, token, or payment. The next decision block distinguishes the $19 one-time private delivery from the $9 event plus buyer-paid Apify usage and explicit total-charge cap before setup detail.
- Observed pattern: Action buyers scan repository description, release activity, copyable workflow, secret requirements, outputs, and failure/cost controls before adoption.
- Hypothesis: presenting a no-account $19 route beside the automated $9-plus-usage route will capture buyers who value the data but do not want to provision Apify. This remains unproven until a source-attributed non-owner order fulfills successfully.

## Rendered QA

- Desktop: `design/renders/github-action-desktop.png` at 1440 x 1000.
- Mobile: `design/renders/github-action-mobile.png` at 390 x 844 after viewport reload.
- Marketplace desktop: `design/renders/github-marketplace-desktop.png` at 1440 x 1000.
- Marketplace mobile: `design/renders/github-marketplace-mobile.png` at 390 x 844 after viewport reload.
- Workflow summary desktop: `design/renders/github-workflow-summary-desktop.png` at 1440 x 1000.
- Workflow summary mobile: `design/renders/github-workflow-summary-mobile.png` at 390 x 844 after viewport reload.
- Desktop exposes the repository job, latest release, Marketplace handoff, source tree, and both paid choices in the README without clipping. Mobile preserves the complete repository description and Marketplace handoff above the file table; GitHub places the README below that table.
- The Marketplace desktop first screen exposes `v1.0.4`, the no-account preview, the $19 direct purchase, the $9 automation route, and the copyable workflow. The Marketplace mobile first screen exposes the listing title, latest version, primary action, and preview promise; the paid-choice block follows in normal document flow.
- The desktop run summary shows success, delivered count, current CMS period, state filter, authoritative source, limitation, and the $19 and $9 handoffs in one viewport. The 390 x 844 mobile first screen shows successful fulfillment, summary heading, and delivered count; the decision block remains below in normal document flow.
- The two prices are not presented as equivalent hidden fees: $19 is a one-time, non-updating private download requiring no Apify account; $9 is an event charge for automation with separately disclosed bounded buyer-paid usage.
- All six reviewed surfaces rendered without horizontal overflow, and the browser console reported no errors or warnings during final QA.

## Findings

- **Closed — high:** release `v1.0.4` and floating tag `v1` deliver a real no-token preview with a source-linked conversion summary; the live Marketplace listing identifies `v1.0.4` as latest.
- **Closed — high:** weekly and manual production-preview verification now invokes the public release without a secret and fails if the filtered JSON output is missing, empty, malformed, or contains an unexpected state.
- **Closed — medium:** the public README and run summary give non-automation buyers a direct $19 purchase path while preserving the separately bounded $9 Apify automation route.
- **Closed — medium:** buyer-intent repository metadata now makes the Action rank in GitHub's top four for all three monitored product/use-case searches without creating another thin repository.
- **Open — low:** GitHub's mobile file table remains ahead of the README, so the copyable workflow is below the first screen.
- **Open — low:** GitHub's Marketplace mobile layout places the paid-choice block below the initial 390 x 844 viewport. The headline, exact data job, latest version, and primary action remain visible before scrolling; GitHub controls this layout.

Any source, tag, release, or Marketplace-state change after the revisions above, or any public repository metadata change after `2026-07-19`, invalidates this review.
