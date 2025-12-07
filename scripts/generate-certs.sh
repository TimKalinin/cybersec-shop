#!/usr/bin/env bash
set -euo pipefail
CERT_DIR=${1:-certs}
mkdir -p "$CERT_DIR"

# Generate CA
openssl req -x509 -new -nodes -days 365 -newkey rsa:4096 \
  -subj "/C=US/ST=CA/L=SF/O=CyberSecShop/OU=CA/CN=CyberSecShop-CA" \
  -keyout "$CERT_DIR/ca.key" -out "$CERT_DIR/ca.crt"

# Server certificate
openssl req -new -nodes -newkey rsa:4096 \
  -subj "/C=US/ST=CA/L=SF/O=CyberSecShop/OU=Server/CN=example.com" \
  -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.csr"
openssl x509 -req -in "$CERT_DIR/server.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" \
  -CAcreateserial -out "$CERT_DIR/server.crt" -days 365 -sha256 \
  -extfile <(printf "subjectAltName=DNS:example.com,DNS:api.example.com")

# Client certificate
openssl req -new -nodes -newkey rsa:4096 \
  -subj "/C=US/ST=CA/L=SF/O=CyberSecShop/OU=Client/CN=demo-client" \
  -keyout "$CERT_DIR/client.key" -out "$CERT_DIR/client.csr"
openssl x509 -req -in "$CERT_DIR/client.csr" -CA "$CERT_DIR/ca.crt" -CAkey "$CERT_DIR/ca.key" \
  -CAcreateserial -out "$CERT_DIR/client.crt" -days 365 -sha256 \
  -extfile <(printf "subjectAltName=DNS:demo-client")

openssl pkcs12 -export -out "$CERT_DIR/client.p12" -inkey "$CERT_DIR/client.key" -in "$CERT_DIR/client.crt" -passout pass:password

cat <<INFO
Certificates generated in $CERT_DIR
- ca.crt/ca.key: CA pair
- server.crt/server.key: server TLS
- client.crt/client.key/client.p12: client mTLS bundle (password: password)
INFO
