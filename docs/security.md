# Security

## Secrets Management
We use SOPS with Age for encrypting secrets. Never commit `secrets/secrets-plaintext.yaml`.

## Network Security
- mTLS is enforced for all service access via Nginx.
- WireGuard is used for secure communication between clients and the server.
- Firewalls are configured on both server and clients.

## User Access
- Kibana and Grafana require authentication.
- Default passwords must be changed in production.
