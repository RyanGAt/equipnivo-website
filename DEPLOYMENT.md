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
