# Production-Ready PHP Docker Images with Essential Extensions

[![image](https://github.com/sitespanel/php-docker/actions/workflows/image.yml/badge.svg)](https://github.com/sitespanel/php-docker/actions/workflows/image.yml) [![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/sitespanel/php-docker/badge)](https://scorecard.dev/viewer/?uri=github.com/sitespanel/php-docker)

> **SitesPanel image source.** GitHub Actions builds this image and publishes it to the GitHub Container Registry as `ghcr.io/sitespanel/php`; see [BUILD.md](BUILD.md).


High-performance, production-ready **PHP-FPM** and **PHP-CLI** Docker images, packed with extensions and tools to supercharge any modern PHP application.

---

## ✨ Why These Images?

*   **Batteries Included**: 50+ optimized PHP extensions, Composer, WP-CLI, and a configurable Node.js version (defaults to 24).
*   **Production Optimized**: Built on official `php` trixie bases with `php.ini-production` settings.
*   **Multi-Version**: Maintained builds for PHP 8.2, 8.3, 8.4, and 8.5.
*   **CI/CD Ready**: Lightweight and perfect for automated build pipelines.

---

## Ideal For

These images are optimized for a wide range of PHP applications, including:

*   **Laravel**: Ready for queues, broadcasting, and Octane.
*   **Symfony**: All the necessary extensions for a full-featured Symfony project.
*   **WordPress**: Includes WP-CLI and all recommended PHP extensions.
*   **Custom Applications**: A solid foundation for any modern PHP project.

---

## Quick Start

The recommended way to use these images is to reference them from the GitHub Container Registry (`ghcr.io/sitespanel`) in your `docker-compose.yml` or `Dockerfile`.

### For Web Applications (FPM)
```yaml
# docker-compose.yml
services:
  php:
    image: ghcr.io/sitespanel/php:8.4-fpm
    volumes:
      - ./src:/var/www/html

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./src:/var/www/html
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
```

### For CLI Tasks
```bash
# Run Composer install
docker run --rm -v $(pwd):/app ghcr.io/sitespanel/php:8.4-cli composer install

# Run a specific PHP script
docker run --rm -v $(pwd):/app ghcr.io/sitespanel/php:8.4-cli php your-script.php
```

---

## Building Locally

If you need to customize the images, you can build them locally. This is useful for changing the Node.js version or adding build-time dependencies.

Clone the repository and use the `--build-arg` flag (every build argument is listed in [EXTENSIONS.md](EXTENSIONS.md#build-arguments)):
```bash
git clone https://github.com/sitespanel/php-docker.git
cd php-docker

# Build a PHP 8.4 image with Node.js 22
docker build . \
  --build-arg PHP_VERSION=8.4 \
  --build-arg IMAGE_TYPE=fpm \
  --build-arg NODE_VERSION=22 \
  --build-arg NODE_PACKAGE_VERSION=<a 22.x package from deb.nodesource.com> \
  -t my-custom-php:8.4-fpm
```

---

## What's Inside?

### PHP Extensions
We include everything you need for modern development. **Every extension and tool, with its version and what it does, is listed in [EXTENSIONS.md](EXTENSIONS.md).**
*   **Performance**: `apcu`, `opcache`, `redis`, `memcached`, `igbinary`.
*   **Databases**: `mysqli`, `pdo_mysql`, `pdo_pgsql`, `pgsql`, `mongodb`.
*   **Async**: `openswoole`, `pcntl`, `sockets`.
*   **Utility & Dev**: `gd`, `intl`, `imagick`, `ftp`, `opentelemetry`, and many more.

### Essential Tools
*   **Composer** (Latest)
*   **WP-CLI** (WordPress command-line support)
*   **Node.js** (Configurable via build arg, defaults to v24)
*   **System Tools**: the MariaDB client (`mariadb`, `mariadb-dump`, also linked as `mysql` and `mysqldump`), `acl`, `ffmpeg`, `zip/unzip`.
*   **Not included**: `supervisor` and `cron`; run workers and schedulers as separate containers.

---

## Tagging Strategy

We prioritize stability. Use explicit tags in your production `Dockerfile`:

| Variant | Use Case |
| :--- | :--- |
| `ghcr.io/sitespanel/php:<version>-fpm` | Production Web Servers |
| `ghcr.io/sitespanel/php:<version>-cli` | Tasks, Migrations, CI/CD Pipelines |

### Base OS

Every version and variant is built on Debian 13 (trixie):

| Tag shape | Base OS |
| :--- | :--- |
| `8.4-fpm`, `8.4-fpm-trixie` | Debian 13 (trixie) |

Only trixie is built; `-trixie` tags are kept as aliases of the unsuffixed ones. bookworm is built again only for a PHP version whose official image has no trixie variant. The old `-bookworm` tags stay in the registry but are no longer updated.

---

## ❓ FAQ

**Q: Can I run custom php.ini configurations?**
A: Absolutely. You can mount your own `php.ini` file into the container (start from [`php.ini.example`](php.ini.example)):
```yaml
    volumes:
      - ./php.ini:/usr/local/etc/php/php.ini:ro
```

**Q: How do I add extensions not in your list?**
A: Since we use the `mlocati/php-extension-installer` utility, you can easily install any other extension via a custom `Dockerfile` layer:
```dockerfile
FROM ghcr.io/sitespanel/php:8.4-fpm
RUN install-php-extensions my-custom-extension
```

**Q: Why Node.js v24?**
A: We prioritize stability and long-term support. Node.js 24 is excellent for modern build tooling like Vite, Webpack, or TailwindCSS.

**Q: How do I manage queues or background processes?**
A: Run them as separate containers from the same image with their own command (for example `php artisan queue:work`); the images no longer include `supervisor` or `cron`.

---

---

## Related Images & Tools

<!-- BEGIN GENERATED: related (from images.yaml in the org .github repository; do not edit by hand) -->
Every image is built by GitHub Actions and published to the GitHub Container Registry (`ghcr.io/sitespanel`), with an SBOM attached to each image.

| Repository | Images | Description |
|---|---|---|
| [caddy-docker](https://github.com/sitespanel/caddy-docker) | `sitespanel-images/caddy` | Standalone Caddy with WAF, rate limiting & caching |
| [frankenphp-docker](https://github.com/sitespanel/frankenphp-docker) | `sitespanel-images/frankenphp` | Caddy + PHP app server in one container |
| [nginx-docker](https://github.com/sitespanel/nginx-docker) | `sitespanel-images/nginx` | nginx with ModSecurity 3, Brotli, zstd & GeoIP2 |
| [apache-docker](https://github.com/sitespanel/apache-docker) | `sitespanel-images/apache` | Apache as a static server or php-fpm application server, no PHP inside |
<!-- END GENERATED: related -->

---

## Feedback and Issues

If you have suggestions, find a bug, or want to request a new extension, please [open an issue](https://github.com/sitespanel/php-docker/issues) on the GitHub repository.

---

⭐ **If this project helps you, consider giving it a star!**
