# Equipnivo deployment — 2026-09-30

Canonical website: https://equipnivo.stackedthink.com
Repository: https://github.com/RyanGAt/equipnivo-website

- Framework: Astro + TypeScript, static output; Barlow Condensed/Inter served locally.
- Identity: angular Equipnivo E mark, oxide red accent, navy/charcoal and sharp industrial layout.
- Routes: home, download/getting started, licence help, 404; SEO, sitemap, robots, PNG Open Graph image and SoftwareApplication data use the Equipnivo domain.
- VPS: 85.190.106.89.
- Root: /var/www/equipnivo-website; current symlink points to an immutable static release.
- Container: equipnivo-website, on the existing coolify network with no public host ports.
- Nginx: /var/www/equipnivo-website/deploy/container-nginx.conf.
- Compose: /var/www/equipnivo-website/deploy/compose.yaml.
- TLS: existing Traefik letsencrypt resolver, automated renewal. HTTP redirects to HTTPS.
- Cloudflare: equipnivo A record → 85.190.106.89, DNS only, TTL Auto.
- Old maintainr.stackedthink.com hostname: permanent redirect to https://equipnivo.stackedthink.com preserving the request path and query. The old container exists only to serve this redirect with its existing certificate.
- Host Nginx remains disabled. Sunshine Plunge, shared proxy, licensing hostname/configuration and Stripe checkout are preserved.

Deployment requires nginx -t before starting/reloading the website Nginx. The old site's Nginx config is backed up before installing its redirect. The website source is pushed to main and the static release is identified in /var/www/equipnivo-website/deployed-commit.txt.

No installer has been published. Download labels remain coming soon. Application release plan: APP-RENAME-PLAN.md. Production checkout and licensing may still show the old product name until the separately approved cutover.

## Verified release

Static source commit: `855a5064c7c36a42dafe245b33e7aceeacacbe0e`, deployed at `/var/www/equipnivo-website/releases/855a5064c7c36a42dafe245b33e7aceeacacbe0e`.

Astro check: zero errors, warnings or hints. Production build: four static pages. Desktop and 390px mobile layouts inspected, without horizontal overflow. Built HTML/CSS/robots/sitemap contain no previous product name or licence prefix.

Public DNS resolves to the VPS. HTTPS validation passes; certificate SAN is equipnivo.stackedthink.com, issued by Let's Encrypt, expires 2026-12-29. Home, download, licence help, robots, sitemap, social image and favicon return 200; a nonexistent route returns 404. The old HTTPS URL redirects with status 301 and preserves paths/query strings. Sunshine Plunge HTTPS returns 200.

The old redirect configuration backup is `/var/www/maintainr-website/deploy/container-nginx.before-equipnivo.conf`. It was tested with nginx -t before reloading only the old website container. No shared proxy restart was required.

## Windows trial download — 2026-09-30

The initial Equipnivo 1.0.0 trial candidate is served from `/var/www/equipnivo-website/downloads/Equipnivo-1.0.0-Windows-x64.exe`, outside the static-release symlink. Nginx aliases `/downloads/` to that persistent directory. Directory listing is disabled; EXE uses application/octet-stream, checksum uses text/plain, and range requests work. SHA-256 sidecar is provided. Configuration backup: `container-nginx.before-downloads.conf`; nginx -t passed before the website-only reload.

The app source is now RyanGAt/Equipnivo. This installer includes .NET and local fonts; the app and local licensing smoke tests pass. Administrator installation/upgrade/uninstall still need clean-machine verification. The candidate is unsigned.

Paid purchase links on this website are paused and lead to the licensing availability notice. Read-only checks found that license.stackedthink.com has no DNS and Stripe has no webhook endpoint; no paid sessions exist for the configured payment link. Its current name/metadata already use Equipnivo. Production setup is reported in the app repository at docs/PRODUCTION-LICENSING.md and awaits the user's decision. No live Stripe mutation was performed.

Production licensing is now deployed following explicit user authorization. The live Stripe webhook and licence-key redirect are configured; fresh checkout fields match product=equipnivo, major_version=1, GBP/7900 and the preserved Payment Link ID. Valid/invalid signatures and no-licence unpaid handling passed on production; paid fulfillment was verified against an isolated copy of fresh checkout fields. No live payment was made. Purchase links are restored. See the app repository's docs/PRODUCTION-LICENSING.md for the current deployment.

