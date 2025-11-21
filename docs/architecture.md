# Architecture

## Components
- **Elasticsearch**: Log storage and indexing.
- **Logstash**: Log processing pipeline.
- **Kibana**: Log visualization.
- **Prometheus**: Metrics collection and storage.
- **Grafana**: Metrics visualization.
- **Alertmanager**: Alert handling.
- **Nginx**: Reverse proxy with mTLS.
- **NixOS**: Operating system for server and clients.
- **WireGuard**: VPN for secure communication.

## Data Flow
1. Clients (Filebeat/Node Exporter) send data to Server (Logstash/Prometheus) via WireGuard.
2. Logstash processes logs and sends to Elasticsearch.
3. Prometheus scrapes metrics.
4. Users access dashboards via Nginx (mTLS).
