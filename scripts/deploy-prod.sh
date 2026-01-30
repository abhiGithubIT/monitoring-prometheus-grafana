#!/bin/bash
set -e

BASE_DIR="$HOME/monitoring-poc"
PROD_DIR="$BASE_DIR/prod"
STAGE_DIR="$BASE_DIR/stage"

echo "====================================="
echo " Deploying PROD environment..."
echo "====================================="

# -------------------------------
# [1/7] Create directory structure
# -------------------------------
echo "[1/7] Creating PROD directories..."
mkdir -p "$PROD_DIR/prometheus"
mkdir -p "$PROD_DIR/prometheus-data"
mkdir -p "$PROD_DIR/grafana-data"

# ----------------------------------------
# [2/7] Copy Prometheus config from STAGE
# ----------------------------------------
echo "[2/7] Copying Prometheus config from STAGE -> PROD..."
cp "$STAGE_DIR/prometheus/prometheus.yml" \
   "$PROD_DIR/prometheus/prometheus.yml"

# ----------------------------------------
# [3/7] Create docker-compose.yml
# ----------------------------------------
echo "[3/7] Creating PROD docker-compose.yml..."
cat > "$PROD_DIR/docker-compose.yml" <<EOF
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus_prod
    ports:
      - "9091:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./prometheus-data:/prometheus
    restart: always

  grafana:
    image: grafana/grafana:latest
    container_name: grafana_prod
    ports:
      - "3001:3000"
    volumes:
      - ./grafana-data:/var/lib/grafana
    restart: always

  node_exporter:
    image: prom/node-exporter:latest
    container_name: node_exporter_prod
    ports:
      - "9101:9100"
    restart: always
EOF

# --------------------------------------------------
# [4/7] Restore Grafana data from STAGE (if exists)
# --------------------------------------------------
echo "[4/7] Restoring Grafana data from STAGE (if present)..."
if [ -d "$STAGE_DIR/grafana-data" ]; then
  sudo rsync -a "$STAGE_DIR/grafana-data/" "$PROD_DIR/grafana-data/"
else
  echo "No STAGE Grafana data found, skipping restore."
fi

# ----------------------------------------
# [5/7] Fix host volume permissions
# ----------------------------------------
echo "[5/7] Fixing volume permissions..."

# Grafana → UID 472
sudo chown -R 472:472 "$PROD_DIR/grafana-data"

# Prometheus → UID 65534 (nobody)
sudo chown -R 65534:65534 "$PROD_DIR/prometheus-data"

# ----------------------------------------
# [6/7] Start PROD containers
# ----------------------------------------
echo "[6/7] Starting PROD containers..."
cd "$PROD_DIR"
docker compose up -d

# ----------------------------------------
# [7/7] Final status
# ----------------------------------------
echo "====================================="
echo " ✅ PROD Deployment Completed"
echo "====================================="
echo "PROD URLs:"
echo "Prometheus PROD : http://localhost:9091"
echo "Grafana PROD    : http://localhost:3001"
echo "Node Exporter   : http://localhost:9101/metrics"
echo "====================================="
