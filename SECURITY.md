# Security Policy

## Supported Versions

| Version | Variant | Supported          |
|---------|---------|--------------------|
| 8.5     | fpm/cli | :white_check_mark: |
| 8.4     | fpm/cli | :white_check_mark: |
| 8.3     | fpm/cli | :white_check_mark: |
| 8.2     | fpm/cli | :white_check_mark: |

## Reporting a Vulnerability

**Please report privately**, using GitHub's private vulnerability reporting:

- [Report a vulnerability](https://github.com/sitespanel/php-docker/security/advisories/new)

That keeps the details between us until there is a fix to ship. Please do not open a public
issue for a security problem — a public issue discloses the vulnerability to everyone,
including anyone who would use it, before there is anything to upgrade to.

Please include:
- A clear description of the vulnerability
- Steps to reproduce
- The image tag/version affected

We aim to respond within 48 hours and publish a fix as soon as possible.

## Supported Base Images

These images are built on top of:
- [docker-library/php](https://github.com/docker-library/php) — Official PHP Docker images
- [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer) — PHP extension installer

If a vulnerability exists in an upstream component, we will update to the patched version and release updated images.
