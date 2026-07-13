# GitHub Marketplace and Action repository design review

Reviewed: 2026-07-13  
Source revision: `6714c97d0e69ad6c1145ba41e6347c0cc4e66877`
Surfaces: <https://github.com/marketplace/actions/new-behavioral-health-practices-weekly> and <https://github.com/unitedideas/behavioral-health-practice-leads-action>

## Conversion contract

- Category: developer-tool and lead-generation Action repository.
- Audience: healthcare data teams, billing and credentialing vendors, territory planners, and developers who already automate exports in GitHub Actions.
- Primary conversion: copy the preview workflow, add the buyer's Apify token, then graduate to a cost-capped $9 full-edition run when the sample is useful.
- Conversion-quality metric: non-owner unique repository cloners and Action workflow executions that precede an external paid `weekly-edition` event and successful dataset delivery.

## Evidence and judgment

- Measured evidence: Marketplace release `v1.0.1` is public and points to the reviewed revision; floating tag `v1` resolves to the same revision; the hosted Test workflow passed; GitHub Marketplace returns the listing as the only result for both `new behavioral health practices` and `behavioral health npi`; the listing has no external stars at review time.
- Standards: the first README paragraph names the current weekly event, the default preview, the full-edition price, the total-charge cap, and the buyer-funded credential boundary before setup detail.
- Observed pattern: Action buyers scan repository description, release activity, copyable workflow, secret requirements, outputs, and failure/cost controls before adoption.
- Hypothesis: an exact weekly healthcare-data job with a copyable preview workflow will attract more qualified developer intent than a generic Actor API example.

## Rendered QA

- Desktop: `design/renders/github-action-desktop.png` at 1440 x 1000.
- Mobile: `design/renders/github-action-mobile.png` at 390 x 844 after viewport reload.
- Marketplace desktop: `design/renders/github-marketplace-desktop.png` at 1440 x 1000.
- Marketplace mobile: `design/renders/github-marketplace-mobile.png` at 390 x 844 after viewport reload.
- Desktop exposes the repository job, release, categories, source tree, and README value/price boundary in the first screen.
- Mobile keeps the repository description and Apify destination readable, but GitHub places the file table ahead of the README and renders that table with horizontal overflow. This is controlled by GitHub rather than repository CSS.
- The Marketplace desktop first screen exposes the exact job, free-preview boundary, full-edition price, latest version, categories, and copyable workflow. The Marketplace mobile first screen exposes the title, latest version, primary action, exact job, and the opening of the price boundary before normal scrolling.
- Copy, price, secret handling, cost cap, data limitations, and explicit non-outreach boundary are consistent across the repository metadata and README.

## Findings

- **Closed — high:** the separate Marketplace publication step completed at `v1.0.1`; the live listing identifies the release as latest and exposes API Management and Utilities categories.
- **Open — low:** GitHub's mobile file table introduces horizontal scrolling before the README. The value proposition remains readable in the repository description, but the copyable workflow is below the first screen.
- **Open — low:** GitHub's Marketplace mobile layout places the full $9 sentence just below the initial 390 x 844 viewport. The headline, exact data job, latest version, and primary action remain visible before scrolling; GitHub controls this layout.

Any source, metadata, tag, release, or Marketplace-state change after the revision above invalidates this review.
