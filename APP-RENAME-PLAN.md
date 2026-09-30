# Equipnivo v1.0.0 — application rename plan

Published by StackedThink. Audit performed 2026-09-30 against `RyanGAt/Maintainr` main, commit `07404c2ed2191716d7617e2925ef669525f7a322`. This is a source audit and implementation plan. Application code, live Stripe configuration and the production licensing service have not been changed by the website rename.

## Target identity

- Product: **Equipnivo**, tagline **Maintenance / Simplified**.
- Positioning: **Maintenance tracking without the enterprise software.**
- Publisher: **StackedThink**.
- Website: https://equipnivo.stackedthink.com.
- Website repository: `RyanGAt/equipnivo-website`.
- Proposed application repository: `RyanGAt/Equipnivo` (rename before public release; not changed during this audit).
- Release/tag: **Equipnivo v1.0.0** / `v1.0.0`.
- Installer: `Equipnivo-1.0.0-Windows-x64.exe`.
- Windows host executable: `Equipnivo.exe`; explicitly set assembly/product/company/version metadata rather than relying on a renamed folder.
- Proposed licence prefix: `EQN1-`; product payload and checkout metadata ID: `equipnivo`; major version remains `1`.
- Licensing hostname stays `license.stackedthink.com`. Keep the £79 price, one-installation entitlement, unlimited staff and offline certificate verification.

## Customer-facing audit

| Area | Confirmed source | Required change |
| --- | --- | --- |
| Login, initial admin setup, navigation and header | `frontend/src/App.vue` lines 56, 60, 77–99 | Replace visible name and all three M badges with the angular Equipnivo E. Use the website's SVG geometry; retain readable wordmark and tagline. |
| Browser/window title | `frontend/index.html` currently contains only the mount element and module script | Add a proper HTML document, title `Equipnivo`, favicon and viewport metadata. If a desktop shell/tray launcher is added, title it Equipnivo too. No shell currently exists in the tree. |
| First equipment setup | `frontend/src/views/Dashboard.vue` lines 91–148 | Rename headings, explanatory text, submit label and ready message. |
| Trial upgrade modal | `frontend/src/views/Assets.vue` lines 183–190 | Rename trial text and upgrade button. Keep the 10 active equipment limit. |
| Settings and licence UI | `frontend/src/views/Settings.vue` lines 83–100 and 122–230 | Rename settings, activation/deactivation feedback, buy button, network explanation and data path label. Switch both licence placeholders to EQN1 only when the issuer is changed. |
| API error messages | `backend/Maintainr.Api/Program.cs` lines 94, 124, 241 and `LicenseService.cs` lines 87, 98, 132 | Rename trial, setup, admin and licence errors. Keep role and validation behaviour. |
| Purchase success page | `licensing/Maintainr.Licensing.Api/Program.cs` lines 183–211, 251 | Rename browser title, StackedThink product label, purchase status, activation guidance and already-active error. This page is served by licensing production, so stage it with the coordinated licensing release. |
| Docs | Root `README.md`, `docs/architecture.md`, `licensing/deploy/README.md` | Rewrite commands, paths, product identity and examples; remove outdated milestone/status claims when implementing the release. |
| Screenshots/assets | Recursive repository tree | No committed screenshots, logo files, installer scripts or release binaries were found. Capture genuine app screenshots after the rename; do not recreate fake UI. |

## Executables, projects and configuration

Rename `backend/Maintainr.Api/` and its project to `backend/Equipnivo.Api/Equipnivo.Api.csproj`. Use `Equipnivo.Api` for the namespace and `EquipnivoDbContext` for the context class; update usages in Program, models, auth and seed code together. Set a deliberate executable assembly name `Equipnivo`, Product `Equipnivo`, Company `StackedThink` and Version `1.0.0`. Confirm publish output names in packaging rather than assuming the `.csproj` rename sets all Windows metadata.

Rename the licensing source project/namespace to `Equipnivo.Licensing.Api` when preparing its staged release. Namespace and project-folder changes are straightforward here; no namespace names should become database table renames. Preserve database schema semantics.

Keep generic local API routes (`/api/assets`, `/api/maintenance`, `/api/faults`, `/api/history`, `/api/auth`, `/api/license`) and licensing routes (`/api/licensing/activate`, `/api/licensing/deactivate`, `/purchase/success`, `/webhooks/stripe`, `/health`) stable. They are functional names rather than product branding; do not rename endpoints for cosmetic reasons. The identity-bearing certificate payload and webhook metadata are the API identifiers that need coordinated changes.

`frontend/package.json` is `maintainr-frontend` version `0.1.0`: change to `equipnivo-frontend` / `1.0.0` and regenerate the lockfile if one is introduced. The app has no committed lockfile today.

Replace the configuration section `Maintainr` with `Equipnivo` in backend appsettings, `Program.cs`, `LicenseService.cs` and documented environment variables. Current keys are `UpgradeUrl`, `UpgradePrice`, `LicenseServerUrl`, `SeedDemoData` and `Licensed`. The development-only licensed override must stay development-only. Keep generic `Licensing`, `Stripe`, ASP.NET and Vite configuration keys unchanged. Change `MAINTAINR_API_URL` in `frontend/vite.config.ts` to `EQUIPNIVO_API_URL` and update docs. Keep `VITE_API_BASE_URL` generic.

Change browser storage `maintainr_token` to `equipnivo_token`, event `maintainr-auth-expired` to `equipnivo-auth-expired`, frontend type `MaintainrUser` to `EquipnivoUser`, and `HttpContext.Items["MaintainrUser"]` to `EquipnivoUser` across `auth.ts`, `api.ts`, `LocalAuth.cs` and backend `Program.cs`. Existing development browser sessions can simply sign in again; no legacy aliases are necessary for a pre-release product.

## Local data and installation

The current app derives `../../data` from ContentRootPath in backend `Program.cs` lines 9–15 and stores `maintainr.db`, uploads, backups, installation ID and licence certificate files there. Settings shows `data/maintainr.db`.

For the Windows release, choose one explicit installation-wide writable location, proposed `%ProgramData%\StackedThink\Equipnivo\`, with `equipnivo.db`, `uploads\`, `backups\`, `license.json`, `license-public-key.pem` and `installation-id.txt`. Keep dev data configurable/relative; do not put writable production data under Program Files. Grant access to the service account and intended local admins, not broad unrelated users.

Do not silently abandon or overwrite existing development databases. Back up and manually import needed data into the renamed directory; record that this is a development migration, not a permanent compatibility layer. Decide whether development activations are discarded/reissued before adopting the new product ID. Do not regenerate signing keys merely to rename a product.

No packaged Windows host, installer configuration or public release exists yet. Create packaging that serves the compiled Vue frontend, starts the local server, supports LAN clients and uses the Equipnivo filename, Start menu/tray labels, uninstall entry and E icon. Test a clean Windows x64 installation and uninstall without deleting customer data by default.

## Coordinated licensing and Stripe changes — report first, apply later

The following are proposed changes only. Live Stripe Dashboard/API product settings and transaction counts were not inspected or modified; exact live resources must be read and backed up before implementation. Source defaults reference the existing payment link, not proof of its current live metadata.

1. **Key issuer:** `CertificateSigner.cs` line 56 creates `MNT1-…`. Change only the format prefix to `EQN1-…`; retain cryptographic randomness and hashing. UI examples and docs must match.
2. **Signed product identity:** licensing `Program.cs` line 103 signs product `maintainr`; the local verifier in backend `LicenseService.cs` line 200 requires `maintainr`. Switch both to `equipnivo` in the same staged release. Changing only one side causes paid activation to fail.
3. **Stripe fulfillment filter:** licensing `Program.cs` lines 144–155 requires checkout-session metadata `product=maintainr`, `major_version=1`, the configured payment-link ID, subtotal 7900 and GBP. Change the product filter to `equipnivo` only in coordination with the Payment Link's session metadata. Changing Product metadata alone does not satisfy this filter.
4. **Display identity:** inspect the Stripe Product attached to the existing £79 Price/Payment Link. Rename its customer-facing name and description to Equipnivo V1, plus any relevant receipt/checkout text and product imagery. Keep the current checkout link and Price ID if their existing settings can be edited safely. Do not create a duplicate paid offer without a reason.
5. **Return page/webhook:** preserve `https://license.stackedthink.com/webhooks/stripe` and `/purchase/success?session_id={CHECKOUT_SESSION_ID}`. Stage Equipnivo success-page copy. Preserve webhook signature validation, duplicate-event/idempotent fulfillment, amount/currency checks and one active installation per key.
6. **Existing records:** confirm the no-public-customers assumption by checking purchase/licence/activation records with read-only queries. Back up licensing.db and signing material securely. Explicitly decide the disposition of any test keys/certificates; do not delete them or alter production rows as part of a text rename.
7. **Runtime paths:** `/opt/maintainr-licensing`, `/var/lib/maintainr-licensing`, `/etc/maintainr-licensing.env` and `maintainr-licensing.service` are named in deployment docs. They may remain during the coordinated cutover to reduce operational risk; if renamed, update the unit's WorkingDirectory, DLL path, DataPath, ownership, environment file and backup jobs together. The public hostname remains unchanged.

The website keeps the existing public Stripe URL and uses neutral “full licence key supplied with your purchase” wording rather than falsely advertising EQN1 before the backend issues it. Checkout and activation may still display Maintainr until this plan is implemented. Treat that as a public-launch blocker.

## Implementation order and acceptance

1. Website rename, branding, canonical URL, DNS, HTTPS, SEO and repo rename (this change).
2. Prepare an application rename branch: UI, E mark, messages, docs, namespaces, configuration and data-path/packaging choices. Rename the app repository when its references and deployment tooling have been inventoried.
3. Prepare and test the paired client/licensing `equipnivo` product ID and EQN1 changes against a non-production Stripe setup. Report the exact live changes before applying them.
4. Perform the approved production cutover with backups and rollback to the matched prior client/licensing identity if needed. Do not rotate signing keys without a separate requirement.
5. Publish **Equipnivo v1.0.0** with `Equipnivo-1.0.0-Windows-x64.exe`, checksums and authentic screenshots; then enable the website download URL.

Acceptance checks: Vue typecheck/build and .NET builds; clean Admin setup and Staff PIN login; 10-equipment trial boundary; checks, faults and attributed history; successful payment fulfillment and replayed webhook; EQN1 activation, offline restart, deactivation/transfer and wrong-product certificate rejection; clean Windows installation on the main PC and browser access from a phone; backup/restore; repository-wide naming scan with explicit documented exceptions only.
