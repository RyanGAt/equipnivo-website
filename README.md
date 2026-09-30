# Equipnivo public website

Standalone Astro + TypeScript static marketing site for https://equipnivo.stackedthink.com. This repository contains no Equipnivo application or licensing service code. No database or runtime backend is needed.

## Development

Use Node.js >=22.12 and npm >=9.6.5.

```sh
npm ci
npm run dev
npm run check
npm run build
npm run preview
```

Production output is in `dist/`. Fonts are served locally via Fontsource; no third-party analytics or tracking scripts are included.

## Content and URLs

- `src/config.ts`: existing public Stripe payment link, Windows installer URL and version, canonical site URL.
- `src/pages/index.astro`: features, architecture, pricing, FAQ, SoftwareApplication schema.
- `/download/`: trial and getting started. `/licence-help/`: activation and moving PCs.
- `public/robots.txt` and `public/sitemap.xml`: update these if adding routes or changing the domain.
- Product facts were checked against RyanGAt/Maintainr main at `07404c2ed2191716d7617e2925ef669525f7a322` on 2026-09-30. No releases or screenshot assets existed then. No fabricated screenshots are used.

### Enabling the installer

Check the application repository's GitHub releases for a stable Windows installer asset (not a source archive, draft or prerelease). Verify the installer is publicly downloadable and test it. Set `windowsDownload` to its exact asset URL and `downloadVersion` to its release version in `src/config.ts`, then check, build and deploy. The website will automatically change its download labels. Do not set a guessed installer URL.

## VPS deployment

Host: `85.190.106.89`, SSH user `administrator`. Keep credentials outside this repository.

Static release layout:

```text
/var/www/equipnivo-website/releases/<release-id>/
/var/www/equipnivo-website/current -> releases/<release-id>
/var/www/equipnivo-website/deploy/compose.yaml
/var/www/equipnivo-website/deploy/container-nginx.conf
```

Build locally, archive the contents of `dist/`, upload with scp, extract into a new release directory and atomically replace the `current` symlink. Record the deployed commit. Keep old releases for rollback. Do not upload source credentials or node_modules.

The active VPS entry point is Coolify's Traefik proxy, with HTTP/HTTPS on ports 80/443. Host Nginx is disabled. Do not start host Nginx or replace the proxy. This site's dedicated Nginx container joins the existing `coolify` Docker network and publishes no host ports. Only the Equipnivo hostname routes to it. The Nginx image is pinned to the digest verified at initial deployment.

For initial setup, inspect the active proxy and existing routes and preserve them. Copy `deploy/container-nginx.conf`, `deploy/compose.yaml` and `deploy/install-container.sh` to the server as `/home/administrator/equipnivo-container-nginx.conf`, `/home/administrator/equipnivo-compose.yaml` and `/home/administrator/equipnivo-install-container.sh`. The static release and `current` symlink must exist first. Run the install script; it validates Compose and runs `nginx -t` in a temporary container before starting the site.

For Nginx configuration edits, back up the current file, update it, run `sudo docker exec equipnivo-website nginx -t` and reload using `sudo docker exec equipnivo-website nginx -s reload` only after validation succeeds. A failed test requires restoring the previous file without reloading. The site root is mounted as a parent directory so an atomic `current` symlink change works for content-only releases.

### DNS and HTTPS

If DNS is absent, create the following Cloudflare record in the stackedthink.com zone:

| Type | Name | IPv4 | Proxy | TTL |
| --- | --- | --- | --- | --- |
| A | equipnivo | 85.190.106.89 | DNS only for initial certificate issuance | Auto |

No AAAA record is needed unless the VPS IPv6 address has been verified. Make no unrelated DNS changes.

Once public DNS resolves correctly, Traefik's existing `letsencrypt` resolver can issue the certificate for the dedicated HTTPS route. DNS and certificate issuance are complete. The following redirect labels are enabled on the website service:

```sh
traefik.http.middlewares.equipnivo-redirect.redirectscheme.scheme: https
traefik.http.middlewares.equipnivo-redirect.redirectscheme.permanent: 'true'
traefik.http.routers.equipnivo-website-http.middlewares: equipnivo-redirect
```

Validate Compose, test Nginx and apply with `sudo docker compose -f /var/www/equipnivo-website/deploy/compose.yaml up -d`. Confirm HTTPS returns 200, HTTP redirects to HTTPS and the certificate matches the domain. Traefik handles automatic renewal through its existing ACME storage. Do not edit or publish that storage. Check `/download/`, `/licence-help/`, `/robots.txt`, `/sitemap.xml` and a missing path (404), then verify the existing Sunshine Plunge host still works.

Rollback static content by replacing the `current` symlink with the previous release. Nginx does not need reloading for a content-only deployment.

## Application rename audit

See APP-RENAME-PLAN.md for the audited application rename and the proposed coordinated Stripe/licensing cutover. Production Stripe and licensing remain unchanged. The current checkout and licence success page may still use the previous product identity until that cutover is approved.

The old product hostname redirects permanently to Equipnivo; it is never canonical.
