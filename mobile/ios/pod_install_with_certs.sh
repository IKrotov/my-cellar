#!/bin/bash
# Workaround for CocoaPods SSL "certificate verify failed" on macOS.
# Sets SSL_CERT_FILE to a known CA bundle before running pod install.

set -e
cd "$(dirname "$0")"

PREFIX=$(brew --prefix 2>/dev/null || true)
for cert in \
  "$PREFIX/etc/openssl@3/cert.pem" \
  "$PREFIX/etc/openssl@1.1/cert.pem" \
  "$PREFIX/etc/openssl/cert.pem" \
  "$(brew --prefix openssl 2>/dev/null)/etc/openssl/cert.pem" \
  "/etc/ssl/cert.pem"; do
  if [[ -n "$cert" && -f "$cert" ]]; then
    export SSL_CERT_FILE="$cert"
    echo "Using SSL_CERT_FILE=$SSL_CERT_FILE"
    exec pod install "$@"
  fi
done

echo "No CA cert file found. Install OpenSSL and/or CA certs, then retry:"
echo "  brew install openssl"
echo "  # or: brew install ca-certificates"
echo "Then run this script again, or set SSL_CERT_FILE manually and run: pod install"
exit 1
