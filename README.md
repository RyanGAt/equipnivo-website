# Maintainr public website

Standalone Astro + TypeScript static marketing site for https://maintainr.stackedthink.com. This repository contains no Maintainr application or licensing service code. No database or runtime backend is needed.

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
/var/www/maintainr-website/releases/<release-id>/
/var/www/maintainr-website/current -> releases/<release-id>
/etc/nginx/sites-available/maintainr-website
/etc/nginx/sites-enabled/maintainr-website
```

Build locally, archive the contents of `dist/`, upload with scp, extract into a new release directory and atomically replace the `current` symlink. Record the deployed commit. Keep old releases for rollback. Do not upload source credentials or node_modules.

Before initial Nginx setup, inspect `sudo nginx -T`, back up existing configuration and check for an existing server_name. Install `deploy/nginx.conf` as the separate site above. Enable only this new virtual host. Run `sudo nginx -t` and only reload using `sudo systemctl reload nginx` after validation succeeds. Roll back the new host if validation fails. Existing Sunshine Plunge and licensing hosts must remain unchanged.

### DNS and HTTPS

If DNS is absent, create the following Cloudflare record in the stackedthink.com zone:

| Type | Name | IPv4 | Proxy | TTL |
| --- | --- | --- | --- | --- |
| A | maintainr | 85.190.106.89 | DNS only for initial certificate issuance | Auto |

No AAAA record is needed unless the VPS IPv6 address has been verified. Make no unrelated DNS changes.

Once public DNS resolves correctly, use the VPS's existing Certbot Nginx approach:

```sh
sudo nginx -t
sudo certbot --nginx -d maintainr.stackedthink.com --redirect
sudo nginx -t
sudo systemctl reload nginx
```

Use the server's existing ACME account. Confirm HTTPS returns 200, HTTP redirects to HTTPS, the certificate matches the domain and renewal is enabled. Check `/download/`, `/licence-help/`, `/robots.txt`, `/sitemap.xml` and a missing path (404), then verify the existing Sunshine Plunge host still works.

Rollback static content by replacing the `current` symlink with the previous release. Nginx does not need reloading for a content-only deployment.
