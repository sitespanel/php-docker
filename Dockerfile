# Use a build-time argument to specify the PHP version. Defaulting to 8.4
ARG PHP_VERSION=8.4
# Use a build-time argument to specify the PHP variant (e.g., fpm, cli). Defaulting to fpm.
ARG IMAGE_TYPE=fpm
# Use a build-time argument to specify the Node.js version. Defaulting to 24.
ARG NODE_VERSION=24
# Exact NodeSource package of that Node.js line (24.22.1, NodeSource node_24.x, 2026-10-27).
ARG NODE_PACKAGE_VERSION=24.22.1-1nodesource1
# npm replaces the one bundled with Node: npm 11.19.1 (Node 24.22.1) still bundles
# brace-expansion and undici releases with high CVEs; npm 12.2.2 (2026-11-04) bundles
# undici 6.29.1 and brace-expansion 5.0.12, which fix them (read from the package on
# 2026-11-08; npm 12.2.1 still bundled undici 6.29.0).
ARG NPM_VERSION=12.2.2
# Fingerprint of the NodeSource repository signing key (deb.nodesource.com/gpgkey/nodesource-repo.gpg.key).
ARG NODE_KEY_FPR=6F71F525282841EEDAF851B42F59B5F99B1BE0B4
# Debian release of the base image. Only trixie is built; use bookworm here only
# for a PHP version whose base image has no trixie variant.
ARG DEBIAN_RELEASE=trixie
# MariaDB release series of the client tools, installed from MariaDB's own apt
# repository (the Debian client is older and conflicts with the official one).
ARG MARIADB_SERIES=12.3
# Fingerprint of the MariaDB release signing key (mariadb.org/mariadb_release_signing_key.asc).
ARG MARIADB_KEY_FPR=177F4010FE56CA3336300305F1656F24C74CD1D8
# WP-CLI release and the SHA-256 of its phar (github.com/wp-cli/wp-cli/releases).
ARG WP_CLI_VERSION=2.12.0
ARG WP_CLI_SHA256=ce34ddd838f7351d6759068d09793f26755463b4a4610a5a5c0a97b68220d85c

# Use the ARG to pull the correct base image
FROM php:${PHP_VERSION}-${IMAGE_TYPE}-${DEBIAN_RELEASE}

LABEL org.opencontainers.image.title="php" \
      org.opencontainers.image.description="PHP-FPM and CLI with 52 extensions, Composer, WP-CLI, the MariaDB client and Node.js" \
      org.opencontainers.image.source="https://github.com/sitespanel/php-docker" \
      org.opencontainers.image.licenses="MIT"

# Re-declare ARGs to be available in subsequent build stages
ARG PHP_VERSION
ARG IMAGE_TYPE
ARG NODE_VERSION
ARG NODE_PACKAGE_VERSION
ARG NPM_VERSION
ARG NODE_KEY_FPR
ARG DEBIAN_RELEASE
ARG MARIADB_SERIES
ARG MARIADB_KEY_FPR
ARG WP_CLI_VERSION
ARG WP_CLI_SHA256

# ==> 0. Refuse a PHP below the fixed releases <==
# CVE-2026-109618 and CVE-2026-109619 (GHSA-w8hw-w9fx-j79w, GHSA-6wmf-4rv5-p3rp) are fixed in 8.2.35, 8.3.36,
# 8.4.27 and 8.5.12. A base image older than that fails the build instead of shipping. Raise the floor when
# a later advisory needs it.
RUN set -eu; \
    case "${PHP_VERSION}" in \
      8.2) min=8.2.35 ;; \
      8.3) min=8.3.36 ;; \
      8.4) min=8.4.27 ;; \
      8.5) min=8.5.12 ;; \
      *) echo "no security floor is set for PHP ${PHP_VERSION}"; exit 1 ;; \
    esac; \
    php -r 'exit(version_compare(PHP_VERSION, $argv[1], ">=") ? 0 : 1);' "$min" \
      || { echo "PHP $(php -r 'echo PHP_VERSION;') is below the fixed release ${min}"; exit 1; }

# ==> 1. Install System Dependencies & Node.js <==
# Install essential system packages and Node.js in a single layer for efficiency.
# The MariaDB client comes from MariaDB's own repository, whose key is checked
# against a pinned fingerprint. MariaDB 11.8 and later ship no mysql-named
# commands, so small wrappers run the mariadb tools under their own names (a
# bare symlink makes every call print a "Deprecated program name" notice).
# Node.js comes from NodeSource's apt repository the same way: key checked against
# a pinned fingerprint, exact package version (no installer script is piped into a shell).
# Debian security fixes released after the official PHP image was built are applied
# first (`apt-get upgrade`), so the build's critical-vulnerability scan does not wait
# for the next upstream rebuild.
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get upgrade -y --no-install-recommends; \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://mariadb.org/mariadb_release_signing_key.asc -o /etc/apt/keyrings/mariadb.asc; \
    gpg --show-keys --with-colons /etc/apt/keyrings/mariadb.asc | grep -q "^fpr:::::::::${MARIADB_KEY_FPR}:"; \
    . /etc/os-release; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key -o /etc/apt/keyrings/nodesource.asc; \
    gpg --show-keys --with-colons /etc/apt/keyrings/nodesource.asc | grep -q "^fpr:::::::::${NODE_KEY_FPR}:"; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.asc] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list; \
    echo "deb [signed-by=/etc/apt/keyrings/mariadb.asc] https://mirror.mariadb.org/repo/${MARIADB_SERIES}/debian ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/mariadb.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        acl \
        mariadb-client \
        dnsutils \
        git \
        gosu \
        jq \
        less \
        libcap2-bin \
        libfcgi-bin \
        libnss3-tools \
        msmtp \
        msmtp-mta \
        netcat-openbsd \
        procps \
        unzip \
        wget \
        zip \
        ffmpeg \
        "nodejs=${NODE_PACKAGE_VERSION}"; \
    for t in mysql:mariadb mysqldump:mariadb-dump mysqlcheck:mariadb-check mysqladmin:mariadb-admin mysqlimport:mariadb-import mysqlshow:mariadb-show; do \
        printf '#!/bin/bash\nexec -a %s /usr/bin/%s "$@"\n' "${t#*:}" "${t#*:}" > "/usr/bin/${t%%:*}"; \
        chmod 0755 "/usr/bin/${t%%:*}"; \
    done; \
    npm install -g "npm@${NPM_VERSION}"; \
    npm cache clean --force; \
    test "$(npm -v)" = "${NPM_VERSION}"; \
    rm -rf /var/lib/apt/lists/* /root/.npm

# ==> 2. Install PHP Extensions <==
# First, copy the main installer utility from the official image
COPY --from=ghcr.io/mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Copy our custom script and data files
COPY ./scripts/install-extensions.sh /usr/local/bin/
COPY ./data/installable-extensions /tmp/installable-extensions
COPY ./data/supported-extensions /tmp/supported-extensions

# Make our script executable, run it with the correct PHP_VERSION,
# and then clean up the temporary files.
RUN chmod +x /usr/local/bin/install-extensions.sh && \
    IPE_ICU_EN_ONLY=1 install-extensions.sh ${PHP_VERSION} && \
    rm /tmp/installable-extensions /tmp/supported-extensions

# ==> 3. Install Global PHP Tools <==
# Copy Composer from the official image
COPY --from=composer:2.10.3 /usr/bin/composer /usr/local/bin/composer

# Add WP-CLI (WordPress Command Line Interface)
# (a pinned release, verified against its published SHA-256)
RUN set -eux; \
    curl -fsSL -o /usr/local/bin/wp "https://github.com/wp-cli/wp-cli/releases/download/v${WP_CLI_VERSION}/wp-cli-${WP_CLI_VERSION}.phar"; \
    echo "${WP_CLI_SHA256}  /usr/local/bin/wp" | sha256sum -c -; \
    chmod 0755 /usr/local/bin/wp

# ==> 4. Configure PHP <==
# Use the production php.ini configuration file
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# No sendmail_path is baked in: PHP's compiled default (/usr/sbin/sendmail -t -i)
# already resolves to msmtp via msmtp-mta, so mail() works once a deployer supplies
# an SMTP relay in /etc/msmtprc. No php.ini override needed.
