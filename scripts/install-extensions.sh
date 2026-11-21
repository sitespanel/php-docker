#!/bin/bash
set -e

PHP_VERSION=$1
INSTALLABLE_FILE="/tmp/installable-extensions"
SUPPORTED_FILE="/tmp/supported-extensions"

if [ -z "$PHP_VERSION" ]; then
    echo "Usage: $0 <php-version>"
    exit 1
fi

if [ ! -f "$INSTALLABLE_FILE" ]; then
    echo "Error: $INSTALLABLE_FILE not found"
    exit 1
fi

if [ ! -f "$SUPPORTED_FILE" ]; then
    echo "Error: $SUPPORTED_FILE not found"
    exit 1
fi

echo "Generating extension list for PHP $PHP_VERSION..."

# Use awk for efficient processing:
# 1. Read all installable extensions into an array `installable`.
# 2. Process the supported extensions file.
# 3. If an extension is in our `installable` array, check its supported versions.
# 4. If the current PHP_VERSION is supported, print the extension name.
# 5. Finally, use xargs to format the list for the installer.
EXTENSIONS_TO_INSTALL=$(awk -v version="$PHP_VERSION" '
    FNR==NR { installable[$1]=1; next }
    ($1 in installable) {
        for (i=2; i<=NF; i++) {
            if ($i == version) {
                print $1;
                break;
            }
        }
    }
' "$INSTALLABLE_FILE" "$SUPPORTED_FILE" | xargs)

if [ -n "$EXTENSIONS_TO_INSTALL" ]; then
    echo "Installing: $EXTENSIONS_TO_INSTALL"
    install-php-extensions $EXTENSIONS_TO_INSTALL
else
    echo "No applicable extensions found to install for PHP $PHP_VERSION."
fi
