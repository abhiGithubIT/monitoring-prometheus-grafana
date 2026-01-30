# monitoring-prometheus-grafana
Production-ready monitoring setup using Prometheus and Grafana with custom dashboards, alerting, and separate stage and production configurations.
# Prometheus & Grafana Monitoring Setup

## Overview
This repository contains a production-ready monitoring setup using **Prometheus** and **Grafana**.
It is designed to monitor system-level metrics, visualize resource usage, and trigger alerts for proactive issue detection.

The setup follows DevOps best practices such as:
- Configuration as code
- Environment separation
- Version-controlled dashboards and alert rules

---

## Architecture
- Prometheus collects metrics from Node Exporter and internal endpoints
- Alert rules are defined using PromQL
- Grafana is used for visualization and alert monitoring
- Docker Compose is used to run the stack in Stage and Production environments

---

## Tools & Technologies
- Prometheus
- Grafana
- Node Exporter
- Docker & Docker Compose
- PromQL
- Git & GitHub

---

## Repository Structure
prometheus/ -> Prometheus scrape configuration and alert rules
grafana/
dashboards/ -> Exported Grafana dashboards (JSON)
docker/
stage/ -> Docker Compose for Stage environment
prod/ -> Docker Compose for Production environment


---

## Dashboards
The following Grafana dashboards are included:
- CPU Usage Monitoring
- Memory Usage Monitoring
- Alert Status Dashboard

Dashboards are exported as JSON and stored under `grafana/dashboards`.

---

## Alerting
Prometheus alert rules are defined in `alert.rules.yml` for:
- High CPU usage
- High memory usage
- Node exporter down

Alerts are written using PromQL and evaluated by Prometheus.

---

## Environments
Two environments are maintained:
- **Stage**
- **Production**

Each environment has its own Docker Compose file to ensure isolation and independent monitoring.

---

## How to Run (Docker Compose)

### Stage Environment
```bash
cd docker/stage
docker compose up -d

### Prod Environment
```bash
cd docker/prod
docker compose up -d


---

### 🔹 Author (clean)

```md
## Author
Abhishek M
DevOps Engineer with 4+ years of experience


