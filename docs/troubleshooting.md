# Troubleshooting

## Common Issues

### Elasticsearch not starting
Check `vm.max_map_count`. Run `sysctl -w vm.max_map_count=262144`.

### Client connection failed
Check WireGuard status: `sudo wg show`.
Check firewall logs.

### Certificate errors
Ensure CA certificate is installed on the client machine or browser.
Regenerate certificates using `./scripts/generate-certs.sh` if expired.
