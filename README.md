# 🏭 Industrial 4.0 Monitoring Stack (ExtrusionOS/Spectre)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue.svg)](https://nixos.org/)
[![DevSecOps](https://img.shields.io/badge/DevSecOps-Ready-green.svg)](https://www.devsecops.org/)

> **Production-ready monitoring solution for globally distributed Industrial 4.0 systems running ExtrusionOS and Spectre applications on NixOS infrastructure.**

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technology Stack & Rationale](#technology-stack--rationale)
- [Security Features](#security-features)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Monitoring Capabilities](#monitoring-capabilities)
- [Limitations & Future Improvements](#limitations--future-improvements)

---

## 🎯 Overview

This monitoring stack addresses the challenge of managing distributed industrial systems deployed at customer sites worldwide. It provides:

- ✅ Real-time health monitoring of hosts and in-house applications
- ✅ Anomaly detection and alerting
- ✅ Historical data analysis and statistics
- ✅ Secure secret management
- ✅ Zero-trust security model
- ✅ Minimal operational overhead

### Problem Statement

Managing manual oversight of ExtrusionOS/Spectre systems across multiple customer sites becomes unsustainable as infrastructure scales. This solution provides centralized visibility while maintaining security and compliance requirements for industrial environments.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Monitoring Server (Central)               │
│  ┌────────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐ │
│  │Elasticsearch│  │ Kibana   │  │Prometheus│  │ Grafana  │ │
│  │   (Logs)   │  │(Dashboards)│ │ (Metrics)│  │(Analytics)│ │
│  └────────────┘  └──────────┘  └──────────┘  └──────────┘ │
│         │              │               │             │       │
│  ┌────────────────────────────────────────────────────────┐│
│  │             Nginx (Reverse Proxy + mTLS)               ││
│  └────────────────────────────────────────────────────────┘│
└───────────────────────────┬─────────────────────────────────┘
                            │ mTLS + VPN
                ┌───────────┴───────────┐
                │                       │
        ┌───────▼────────┐      ┌──────▼────────┐
        │   Client Site 1 │      │ Client Site N │
        │                 │      │               │
        │ ┌─────────────┐ │      │┌─────────────┐│
        │ │  Filebeat   │ │      ││  Filebeat   ││
        │ │  (Logs)     │ │      ││  (Logs)     ││
        │ └─────────────┘ │      │└─────────────┘│
        │ ┌─────────────┐ │      │┌─────────────┐│
        │ │Node Exporter│ │      ││Node Exporter││
        │ │  (Metrics)  │ │      ││  (Metrics)  ││
        │ └─────────────┘ │      │└─────────────┘│
        │ ┌─────────────┐ │      │┌─────────────┐│
        │ │ExtrusionOS/ │ │      ││ExtrusionOS/ ││
        │ │  Spectre    │ │      ││  Spectre    ││
        │ └─────────────┘ │      │└─────────────┘│
        └─────────────────┘      └───────────────┘
```

---

## 🛠️ Technology Stack & Rationale

### Core Components

| Component | Purpose | Rationale |
|-----------|---------|-----------|
| **Elasticsearch** | Log aggregation & search | Industry-standard for log management, powerful querying, scales horizontally |
| **Kibana** | Log visualization | Native integration with Elasticsearch, rich dashboards, anomaly detection |
| **Prometheus** | Metrics collection | Pull-based model ideal for dynamic environments, PromQL for complex queries |
| **Grafana** | Metrics visualization | Superior visualization, alerting, supports multiple data sources |
| **Filebeat** | Log shipping | Lightweight, reliable, backpressure handling |
| **Node Exporter** | System metrics | Standard Prometheus exporter, comprehensive hardware/OS metrics |
| **Nginx** | Reverse proxy | mTLS termination, load balancing, secure client authentication |
| **WireGuard** | VPN connectivity | Modern, fast, secure tunneling for distributed sites |
| **SOPS + age** | Secret management | Declarative encryption for NixOS, GitOps-friendly |

### Why This Stack?

1. **ELK Stack**: Best-in-class for log analysis in industrial environments
2. **Prometheus/Grafana**: Time-series metrics with powerful alerting
3. **NixOS Integration**: Declarative configuration, reproducible builds
4. **Security First**: mTLS, VPN, encrypted secrets, least privilege
5. **Operational Simplicity**: Automated deployments, self-healing

---

## 🔒 Security Features

### Defense in Depth

1. **Network Layer**
   - WireGuard VPN for all client-server communication
   - mTLS certificate authentication (no passwords)
   - IP whitelisting per client site

2. **Application Layer**
   - Nginx rate limiting and DDoS protection
   - Read-only Filebeat configurations on clients
   - Separate service accounts per component

3. **Secret Management**
   - SOPS encryption for all secrets
   - Age key rotation support
   - No plaintext credentials in Git

4. **System Hardening**
   - AppArmor profiles for all services
   - Minimal container images (distroless where possible)
   - Automated security updates via NixOS

5. **Audit & Compliance**
   - All access logged to Elasticsearch
   - Immutable audit trail
   - GDPR-compliant data retention policies

---

## 🚀 Quick Start

### Prerequisites

- NixOS 24.05+ (server and clients)
- Docker & Docker Compose (for development)
- `sops` and `age` for secret management
- 4GB RAM minimum (server), 512MB (clients)

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/industrial-monitoring-stack.git
cd industrial-monitoring-stack
```

### 2. Generate Secrets

```bash
# Generate age key for SOPS
age-keygen -o secrets/age-key.txt

# Generate certificates for mTLS
./scripts/generate-certs.sh

# Encrypt secrets
sops -e -i secrets/secrets.yaml
```

### 3. Deploy Monitoring Server

```bash
# Using Docker Compose (development)
docker-compose up -d

# Using NixOS (production)
sudo nixos-rebuild switch --flake .#monitoring-server
```

### 4. Deploy Client Agents

```bash
# On client systems
sudo nixos-rebuild switch --flake .#monitoring-client
```

### 5. Access Dashboards

- **Kibana**: https://monitoring.example.com:5601
- **Grafana**: https://monitoring.example.com:3000

Default credentials are in `secrets/secrets.yaml` (encrypted).

---

## ⚙️ Configuration

### Server Configuration

The monitoring server is configured via `nixos/server/configuration.nix`:

```nix
# Key configuration options
services.elasticsearch.enable = true;
services.kibana.enable = true;
services.prometheus.enable = true;
services.grafana.enable = true;

# Security hardening
security.apparmor.enable = true;
networking.firewall.allowedTCPPorts = [ 443 ];  # Only HTTPS
```

### Client Configuration

Clients use `nixos/client/configuration.nix`:

```nix
# Filebeat for log shipping
services.filebeat = {
  enable = true;
  settings = {
    filebeat.inputs = [
      {
        type = "log";
        paths = [ "/var/log/extrusionos/*.log" ];
      }
    ];
  };
};

# Prometheus Node Exporter
services.prometheus.exporters.node.enable = true;
```

### Secret Management

Secrets are encrypted with SOPS:

```yaml
# secrets/secrets.yaml
elasticsearch_password: ENC[AES256_GCM,data:xyz...]
kibana_encryption_key: ENC[AES256_GCM,data:abc...]
```

---

## 📊 Monitoring Capabilities

### System Metrics (Prometheus)

- CPU usage per core
- Memory utilization and swap
- Disk I/O and space
- Network throughput
- System load averages

### Application Logs (ELK)

- ExtrusionOS process logs
- Spectre application errors
- System journal (systemd)
- Audit logs

### Alerting Rules

Pre-configured alerts for:

- High CPU usage (>80% for 5 min)
- Low disk space (<10%)
- Service failures
- Anomalous log patterns
- Network connectivity issues

### Dashboards

- **System Overview**: All hosts at a glance
- **Application Health**: ExtrusionOS/Spectre status
- **Network**: Bandwidth and latency
- **Security**: Failed auth attempts, anomalies

---

## 🔍 Limitations & Future Improvements

### Current Limitations

1. **Scalability**: Single monitoring server (SPOF)
2. **Bandwidth**: Full log shipping may strain low-bandwidth sites
3. **Storage**: No automated log rotation/archival
4. **Alerting**: Basic rules, no ML-based anomaly detection
5. **Multi-tenancy**: Not optimized for isolating client data

### Roadmap

#### Phase 1 (Q1 2026)
- [ ] High-availability Elasticsearch cluster (3 nodes)
- [ ] Log sampling for bandwidth-constrained sites
- [ ] Automated index lifecycle management (ILM)
- [ ] Machine learning anomaly detection (Elastic ML)

#### Phase 2 (Q2 2026)
- [ ] Multi-tenancy with role-based access control (RBAC)
- [ ] S3-compatible cold storage for historical logs
- [ ] Custom ExtrusionOS/Spectre dashboards
- [ ] Synthetic monitoring (uptime checks)

#### Phase 3 (Q3 2026)
- [ ] OpenTelemetry integration for distributed tracing
- [ ] Predictive maintenance models
- [ ] Mobile app for on-call alerts
- [ ] Integration with ticketing systems (Jira, ServiceNow)

---

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Security Hardening](docs/security.md)
- [Troubleshooting](docs/troubleshooting.md)
- [API Reference](docs/api.md)

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 👥 Authors

- Your Name - Initial work - [YourGitHub](https://github.com/AlexanderMonsanto)

---

## 🙏 Acknowledgments

- Reifenhäuser Group for the industrial use case
- NixOS community for declarative infrastructure
- Elastic and Grafana Labs for excellent monitoring tools

---

**Built with ❤️ for Industrial 4.0**