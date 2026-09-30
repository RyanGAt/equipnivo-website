# Deployment status — 2026-09-30

- Repository: https://github.com/RyanGAt/maintainr-website
- Framework: Astro 7.3.5 + TypeScript, static output.
- Static content release: `8f21be690fdd49f9b211ee5fb5fb44d59a17bd21`.
- VPS: `85.190.106.89`.
- Content: `/var/www/maintainr-website/releases/8f21be690fdd49f9b211ee5fb5fb44d59a17bd21`.
- Active symlink: `/var/www/maintainr-website/current`.
- Container: `maintainr-website`, restart policy `unless-stopped`, no public host ports.
- Nginx: `/var/www/maintainr-website/deploy/container-nginx.conf`, mounted as `/etc/nginx/conf.d/default.conf` in the dedicated container.
- Compose: `/var/www/maintainr-website/deploy/compose.yaml`.
- Routing: existing Coolify Traefik proxy; dedicated domain-only HTTP/HTTPS routes using its existing Let's Encrypt resolver.
- Host Nginx remains disabled. Its existing sites were preserved. The unused new Maintainr host config was removed from sites-enabled and archived under `/home/administrator/maintainr-unused-host-nginx.conf`.
- Pre-change host Nginx backup: `/home/administrator/nginx-before-maintainr-8f21be690fdd49f9b211ee5fb5fb44d59a17bd21.tar.gz`.

## Verification

Astro check: zero errors, warnings and hints. Production build: four static pages. Desktop and 390px mobile layouts inspected; mobile had no horizontal overflow. FAQ expansion verified.

Using explicit Host routing to the VPS: home, download, licence help, robots, sitemap and social image returned 200; a missing path returned 404. The external HTTP request using curl `--resolve` returned 200. Sunshine Plunge HTTPS still returned 200 with certificate validation.

## Pending DNS and HTTPS

Public DNS returned NXDOMAIN for maintainr.stackedthink.com. The domain is not publicly reachable through normal DNS yet. A trusted HTTPS certificate has not been issued. HTTPS routing is prepared, but must not be represented as working HTTPS until DNS and certificate validation pass.

Create a Cloudflare A record: name `maintainr`, IPv4 `85.190.106.89`, DNS only initially, TTL Auto. No unrelated records need changing. Once propagated, verify Traefik certificate issuance and enable the HTTP redirect documented in README.

No Windows release assets exist in RyanGAt/Maintainr as of this check. Download buttons accurately say coming soon. Set the exact installer URL in `src/config.ts` only after a stable publicly downloadable Windows installer exists.

The application repository, Stripe checkout, licensing configuration and license.stackedthink.com were not modified.
