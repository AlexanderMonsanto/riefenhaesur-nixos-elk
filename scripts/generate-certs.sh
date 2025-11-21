#!/bin/bash
set -e

mkdir -p certs
cd certs

# CA
if [ ! -f ca.key ]; then
    openssl genrsa -out ca.key 4096
    openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -subj "/C=DE/ST=NRW/L=Troisdorf/O=Reifenhaeuser/CN=Monitoring CA"
fi

# Server
if [ ! -f server.key ]; then
    openssl genrsa -out server.key 4096
    openssl req -new -key server.key -out server.csr -subj "/C=DE/ST=NRW/L=Troisdorf/O=Reifenhaeuser/CN=monitoring.example.com"
    openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
fi

# Client
if [ ! -f client1.key ]; then
    openssl genrsa -out client1.key 4096
    openssl req -new -key client1.key -out client1.csr -subj "/C=DE/ST=NRW/L=Troisdorf/O=Reifenhaeuser/CN=client1"
    openssl x509 -req -days 365 -in client1.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client1.crt
fi

chmod 600 *.key
echo "Certificates generated in certs/"
