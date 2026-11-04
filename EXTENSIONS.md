# What is in the PHP images

The complete list of PHP extensions and tools in the `europe-docker.pkg.dev/PROJECT/sitespanel-images/php` images. The versions below were read from the **PHP 8.5.11 build on Debian 13 (trixie), 2026-10-10**; other PHP versions are built from the same list, and their extension versions differ. To see what any image has, run:

```bash
docker run --rm europe-docker.pkg.dev/PROJECT/sitespanel-images/php:8.5-trixie php -m          # loaded extensions
docker run --rm europe-docker.pkg.dev/PROJECT/sitespanel-images/php:8.5-trixie php --ri redis  # one extension's details
```

**87 extensions are loaded** by default: 35 compiled into PHP (core) and 52 installed on top (each has an `.ini` file in `/usr/local/etc/php/conf.d/`).

## Core extensions

Compiled into PHP itself or shipped with it by the official base image. They cannot be turned off with an `.ini` file.

| Extension | Version | What it does |
|---|---|---|
| `Core` | 8.5.11 | The PHP language core. |
| `ctype` | 8.5.11 | Character-type checks (`ctype_alpha()` and friends). |
| `curl` | 8.5.11 | HTTP and other transfers through libcurl. |
| `date` | 8.5.11 | Date and time functions and classes. |
| `dom` | 20031129 | DOM API for XML and HTML documents. |
| `fileinfo` | 8.5.11 | Detects file types from content (libmagic). |
| `filter` | 8.5.11 | Input filtering and validation. |
| `hash` | 8.5.11 | Hashing (MD5, SHA-2, SHA-3, xxHash and more). |
| `iconv` | 8.5.11 | Character-set conversion. |
| `json` | 8.5.11 | JSON encoding and decoding. |
| `lexbor` | 8.5.11 | The HTML5 parser used by the DOM extension. |
| `libxml` | 8.5.11 | libxml2 support shared by the XML extensions. |
| `mbstring` | 8.5.11 | Multibyte string handling. |
| `mysqlnd` | mysqlnd 8.5.11 | The native MySQL/MariaDB driver that `mysqli` and `pdo_mysql` use. |
| `openssl` | 8.5.11 | Encryption, signatures and TLS through OpenSSL. |
| `pcre` | 8.5.11 | Perl-compatible regular expressions. |
| `PDO` | 8.5.11 | Database access abstraction layer. |
| `pdo_sqlite` | 8.5.11 | SQLite driver for PDO. |
| `Phar` | 8.5.11 | PHP archives. |
| `posix` | 8.5.11 | POSIX process and system functions. |
| `random` | 8.5.11 | Random number generators and `Random\Randomizer`. |
| `readline` | 8.5.11 | Interactive command-line editing. |
| `Reflection` | 8.5.11 | Introspection of classes, functions and extensions. |
| `session` | 8.5.11 | Sessions. |
| `SimpleXML` | 8.5.11 | Simple object-style access to XML. |
| `SPL` | 8.5.11 | The Standard PHP Library (data structures, iterators, exceptions). |
| `sqlite3` | 8.5.11 | SQLite 3 databases. |
| `standard` | 8.5.11 | The standard function library (strings, arrays, files, math). |
| `tokenizer` | 8.5.11 | Exposes PHP's own tokenizer. |
| `uri` | 8.5.11 | URI parsing (RFC 3986 and WHATWG). |
| `xml` | 8.5.11 | XML parser (expat). |
| `xmlreader` | 8.5.11 | Pull-style XML reader. |
| `xmlwriter` | 8.5.11 | Streaming XML writer. |
| `Zend OPcache` | 8.5.11 | Opcode cache that keeps compiled scripts in shared memory. |
| `zlib` | 8.5.11 | Compression (gzip, deflate) through zlib. |

## Installed extensions

Added to the official image with [`install-php-extensions`](https://github.com/mlocati/docker-php-extension-installer). The list is [`data/installable-extensions`](data/installable-extensions); [`data/supported-extensions`](data/supported-extensions) records which PHP versions each extension supports (synced from upstream). Each one is enabled by a file named `docker-php-ext-<name>.ini` or `xx-php-ext-<name>.ini` in `/usr/local/etc/php/conf.d/`.

| Extension | Version | What it does |
|---|---|---|
| `apcu` | 5.1.28 | In-memory user data cache shared by all requests. |
| `bcmath` | 8.5.11 | Arbitrary-precision decimal arithmetic. |
| `brotli` | 0.21.0 | Brotli compression (`brotli_compress()`). |
| `bz2` | 8.5.11 | bzip2 compression. |
| `calendar` | 8.5.11 | Calendar conversions (Gregorian, Julian, Jewish and others). |
| `csv` | 0.3.0 | Fast CSV reading and writing (PECL `csv`). |
| `decimal` | 2.0.1 | Arbitrary-precision decimal numbers (PECL `decimal`). |
| `ds` | 2.0.0 | Efficient data structures (vector, map, set, deque and others). |
| `enchant` | 8.5.11 | Spell-checking through Enchant. |
| `exif` | 8.5.11 | Reads image metadata (EXIF). |
| `FFI` | 8.5.11 | Foreign function interface: call C libraries from PHP. |
| `ftp` | 8.5.11 | FTP client. |
| `gd` | 8.5.11 | Image creation and processing. |
| `gettext` | 8.5.11 | Message translation through gettext. |
| `gmp` | 8.5.11 | Arbitrary-size integers through GNU MP. |
| `gnupg` | 1.5.4 | Encryption and signing through GnuPG. |
| `http` | 4.3.1 | Extended HTTP client and server utilities (PECL `http`, `pecl_http`). Needs `raphf`. |
| `igbinary` | 3.2.17RC1 | Compact binary serializer, also usable by `redis`, `memcached` and `apcu`. |
| `imagick` | 3.8.1 | Image processing through ImageMagick. |
| `inotify` | 3.0.1 | Watches files and directories for changes (Linux). |
| `intl` | 8.5.11 | Internationalisation through ICU (locales, collation, formatting, transliteration). |
| `ldap` | 8.5.11 | LDAP client. |
| `mailparse` | 3.2.0 | Parses and manipulates email messages. |
| `maxminddb` | 1.14.0 | Reads MaxMind DB files (GeoIP lookups). |
| `mcrypt` | 1.0.9 | Legacy mcrypt encryption (deprecated; use `sodium` or `openssl`). |
| `memcached` | 3.4.0 | Memcached client (libmemcached). |
| `mongodb` | 2.5.4 | MongoDB driver. |
| `mysqli` | 8.5.11 | MySQL/MariaDB client interface. |
| `OAuth` | 2.0.10 | OAuth 1.0 consumer and provider. |
| `openswoole` | 26.2.0 | Coroutine-based asynchronous networking server (Open Swoole). |
| `opentelemetry` | 1.4.2 | OpenTelemetry auto-instrumentation hooks. |
| `pcntl` | 8.5.11 | Process control (fork, signals). |
| `pdo_mysql` | 8.5.11 | MySQL/MariaDB driver for PDO. |
| `pdo_pgsql` | 8.5.11 | PostgreSQL driver for PDO. |
| `pgsql` | 8.5.11 | PostgreSQL client interface. |
| `pspell` | 1.0.1 | Spell-checking through pspell/aspell. |
| `raphf` | 2.0.2 | Resource and persistent handle factory; a dependency of `http`. |
| `redis` | 6.3.0 | Redis and Valkey client (phpredis). |
| `shmop` | 8.5.11 | Shared-memory blocks. |
| `soap` | 8.5.11 | SOAP client and server. |
| `sockets` | 8.5.11 | Low-level socket interface. |
| `sodium` | 8.5.11 | Modern cryptography through libsodium. |
| `ssh2` | 1.5.0 | SSH2 client, SFTP and SCP (libssh2). |
| `tidy` | 8.5.11 | Cleans and repairs HTML (HTML Tidy). |
| `timezonedb` | 2026.5 | Updated time zone database for the `date` extension (PECL `timezonedb`). |
| `uploadprogress` | 2.0.2 | Reports file-upload progress. |
| `uuid` | 1.3.0 | UUID generation and parsing. |
| `xmlrpc` | 1.0.0RC3 | XML-RPC encoder and decoder. |
| `xsl` | 8.5.11 | XSLT transformations. |
| `yaml` | 2.3.0 | YAML parser and emitter. |
| `zip` | 1.22.8 | Reads and writes ZIP archives. |
| `zstd` | 0.18.0 | Zstandard compression. |

### Turning an installed extension off

Remove its `.ini` file in your own image (`RUN rm /usr/local/etc/php/conf.d/docker-php-ext-<name>.ini`), or build a filtered copy of the directory at start and point PHP at it:

```bash
mkdir -p /tmp/php-conf.d && cp /usr/local/etc/php/conf.d/*.ini /tmp/php-conf.d/
rm /tmp/php-conf.d/docker-php-ext-<name>.ini
export PHP_INI_SCAN_DIR=/tmp/php-conf.d
```

Fewer loaded extensions means less memory per process and a faster start. Measured on the PHP 8.5 image: all of them 60 MB and 140 ms for `php -r 1;`, a set of 16 common ones 39 MB and 73 ms (command-line process, resident memory, so shared pages are included).

## Not included on purpose

These are absent from the images; add them in your own image if you need them.

| Removed | Reason / alternative |
|---|---|
| `supervisor`, `cron` | Run workers and schedulers as separate containers from the same image with their own command. |
| `pcov` | A code-coverage tool for tests. Collect coverage with a CI image. |
| `grpc`, `protobuf` | Large and slow to compile. Install with `install-php-extensions grpc protobuf`. |
| `rdkafka`, `amqp` | Message-queue clients. Install with `install-php-extensions rdkafka amqp`. |

## Tools

| Tool | Version | Notes |
|---|---|---|
| PHP | 8.5.11 (NTS) | The tag selects the version: 8.2, 8.3, 8.4 or 8.5. |
| Composer | 2.10.3 |  |
| WP-CLI | 2.12.0 | A pinned release, checked against its published SHA-256 at build time (`WP_CLI_VERSION`, `WP_CLI_SHA256`). |
| Node.js / npm | 24.21.0 / 11.19.0 | Major version set by the `NODE_VERSION` build argument (default 24). |
| MariaDB client | 12.3.3 | From MariaDB's own apt repository (series set by `MARIADB_SERIES`; the repository key is checked against a pinned fingerprint). The `mysql`, `mysqldump`, `mysqlcheck`, `mysqladmin`, `mysqlimport` and `mysqlshow` commands are small wrappers for the `mariadb*` tools, which run under their own names so that no "Deprecated program name" notice is printed. There is no MySQL client. |
| libfcgi-bin (`cgi-fcgi`) | 2.4.5 | Query PHP-FPM's status page from a script. |
| ImageMagick | 7.1.1-43 |  |
| ffmpeg | 7.1.5 |  |
| msmtp / msmtp-mta | 1.8.28 | Provide your SMTP relay in `/etc/msmtprc`; see the comment in the Dockerfile for how `mail()` is wired. |
| gosu | 1.17 | Drops privileges from an entrypoint. |
| acl (`setfacl`, `getfacl`) | 2.3.2 | POSIX ACLs. |
| git, curl, wget, jq, zip, unzip, less, procps, netcat-openbsd, dnsutils, libcap2-bin, libnss3-tools | Debian 13 packages |  |

## Build arguments

| Argument | Default | Meaning |
|---|---|---|
| `PHP_VERSION` | `8.4` | PHP branch: 8.2, 8.3, 8.4 or 8.5 |
| `DEBIAN_RELEASE` | `trixie` | `trixie` (the only one built) or `bookworm` for a PHP version without a trixie base image |
| `NODE_VERSION` | `24` | Node.js major version |
| `MARIADB_SERIES` | `12.3` | MariaDB client series |
| `MARIADB_KEY_FPR` | pinned | Expected fingerprint of MariaDB's release signing key |
| `WP_CLI_VERSION`, `WP_CLI_SHA256` | `2.12.0`, pinned | WP-CLI release and its checksum |
| `IMAGE_TYPE` | `fpm` | `fpm` or `cli` |
