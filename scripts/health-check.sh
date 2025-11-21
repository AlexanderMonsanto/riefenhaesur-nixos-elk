#!/bin/bash
set -e

echo "Running health checks..."

# Elasticsearch
echo -n "Elasticsearch: "
curl -sf http://localhost:9200/_cluster/health > /dev/null && echo "✓" || echo "✗"

# Kibana
echo -n "Kibana: "
curl -sf http://localhost:5601/api/status > /dev/null && echo "✓" || echo "✗"

# Prometheus
echo -n "Prometheus: "
curl -sf http://localhost:9090/-/healthy > /dev/null && echo "✓" || echo "✗"

# Grafana
echo -n "Grafana: "
curl -sf http://localhost:3000/api/health > /dev/null && echo "✓" || echo "✗"

# AlertManager
echo -n "AlertManager: "
curl -sf http://localhost:9093/-/healthy > /dev/null && echo "✓" || echo "✗"

echo "Health check complete!"
