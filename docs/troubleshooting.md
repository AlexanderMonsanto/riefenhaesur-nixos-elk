# Troubleshooting Guide

## Common Issues

### Elasticsearch won't start
- Check vm.max_map_count: `sysctl vm.max_map_count`
- Should be at least 262144
- Fix: `sudo sysctl -w vm.max_map_count=262144`

### Services can't connect
- Verify Docker network: `docker network ls`
- Check firewall rules
- Review logs: `make logs`

## Getting Help
- GitHub Issues: <repo-url>/issues
- Documentation: docs/
