# Installation Guide

## Prerequisites
- Docker & Docker Compose
- NixOS (for clients)
- SOPS & Age (for secrets)

## Steps
1. Clone the repository.
2. Run `./scripts/setup.sh` to initialize secrets and certificates.
3. Encrypt secrets using SOPS.
4. Run `docker-compose up -d` to start the server stack.
5. Deploy NixOS clients using the flake.
