# Day 74 -- Node Exporter, cAdvisor, and Grafana Dashboards

## Task
Prometheus is running and you can query metrics. But right now it is only monitoring itself. In production, you need to monitor two critical things: the **host machine** (CPU, memory, disk, network) and the **Docker containers** running on it.

Today you add Node Exporter for host metrics, cAdvisor for container metrics, and set up Grafana to visualize everything in dashboards instead of raw PromQL.

---

## Challenge Tasks

### Task 1: Add Node Exporter for Host Metrics
Node Exporter exposes Linux system metrics (CPU, memory, disk, filesystem, network) in Prometheus format.

Update your `docker-compose.yml` from Day 73 -- add the Node Exporter service:
```yaml
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--path.rootfs=/rootfs'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped
```

**Why these volume mounts?**
- `/proc` -- kernel and process information (CPU stats, memory info)
- `/sys` -- hardware and driver details
- `/` -- filesystem usage (disk space)

All mounted read-only (`ro`) -- Node Exporter only reads, never modifies.

Add it as a scrape target in `prometheus.yml`:
```yaml
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node-exporter"
    static_configs:
      - targets: ["node-exporter:9100"]
```

Restart the stack:
```bash
docker compose up -d
```
<img width="1892" height="611" alt="image" src="https://github.com/user-attachments/assets/bcf9bb76-f2ef-441a-940b-2ab1a7745a9e" />

Verify Node Exporter is healthy:
```bash
curl http://localhost:9100/metrics | head -20
```

Check Prometheus Targets page -- `node-exporter` should show as `UP`.

<img width="1907" height="440" alt="image" src="https://github.com/user-attachments/assets/de36bd1b-9351-4520-90fe-fa42e3ebf6de" />

Run these queries in Prometheus to see host metrics:

promql
# CPU: percentage of time spent idle (per core)
node_cpu_seconds_total{mode="idle"}

<img width="1912" height="482" alt="image" src="https://github.com/user-attachments/assets/0a876237-bf2b-408c-acbc-7f642a6e56fa" />

# Memory: total vs available
node_memory_MemTotal_bytes
node_memory_MemAvailable_bytes

# Memory usage percentage
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```Out of 100% RAM: ~10% is in use```

<img width="1907" height="447" alt="image" src="https://github.com/user-attachments/assets/ca0e0500-a43d-4157-a02c-e60f5099f3f6" />

# Disk: filesystem usage percentage
(1 - node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100
```root filesystem (/) is using approximately 5.60% disk space```

<img width="1915" height="765" alt="image" src="https://github.com/user-attachments/assets/72a7cfd9-42b6-4aee-bb37-b5ae8fccbc9c" />

# Network: bytes received per second
rate(node_network_receive_bytes_total[5m])
```Network receive rate on eth0 is approximately 48 bytes per second```

<img width="1912" height="446" alt="image" src="https://github.com/user-attachments/assets/732da1a0-f770-400f-baea-71256f99984b" />

---

### Task 2: Add cAdvisor for Container Metrics
cAdvisor (Container Advisor) monitors resource usage and performance of running Docker containers.

Add it to your `docker-compose.yml`:
```yaml
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    restart: unless-stopped
```

**Why these volume mounts?**
- Docker socket (`docker.sock`) -- lets cAdvisor discover and query running containers
- `/sys` -- kernel-level container stats (cgroups)
- `/var/lib/docker/` -- container filesystem information

Add cAdvisor as a Prometheus scrape target:
```yaml
  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
```

Restart and verify:
```bash
docker compose up -d
```

Open `http://localhost:8080` to see the cAdvisor web UI. Click on Docker Containers to see per-container stats.

<img width="1597" height="911" alt="image" src="https://github.com/user-attachments/assets/38c24419-9844-4ed3-9867-e1f9a2d4c8de" />

Run these queries in Prometheus:
promql
# CPU usage per container (in seconds)
```rate(container_cpu_usage_seconds_total{id!="/", id=~".*docker.*"}[5m])```

<img width="1924" height="777" alt="image" src="https://github.com/user-attachments/assets/14a81420-c7c9-4ae2-abb3-e56ccd6a7502" />

# Memory usage per container
```container_memory_usage_bytes{id!="/", id=~".*docker.*"}```

<img width="1917" height="770" alt="image" src="https://github.com/user-attachments/assets/09868a92-02a9-48fd-86c7-3acf9091eca5" />

# Network received bytes per container
```rate(container_network_receive_bytes_total[5m])```

<img width="1917" height="460" alt="image" src="https://github.com/user-attachments/assets/8714a2d8-41b7-460d-a551-d02e0c2f954a" />

# Which container is using the most memory?
```topk(3, container_memory_usage_bytes{name!=""})```

<img width="1917" height="470" alt="image" src="https://github.com/user-attachments/assets/a1a7dfc2-6219-4c19-8792-5d743c24b9f8" />

The `{name!=""}` filter removes aggregated/system-level entries and shows only named containers.

  - The {name!=""} filter was not working because the name label is not present in the metric. Instead, {id!="/"} is used to remove aggregated/system-level entries and show container-level data.

**Document:** What is the difference between Node Exporter and cAdvisor? When would you use each?

- `Node Exporter` is used to monitor **host/system-level metrics** like CPU, memory, disk, and network of the entire machine.

- `cAdvisor` is used to monitor **container-level metrics** like CPU and memory usage per container.

- Use `Node Exporter` for **server monitoring** and `cAdvisor` for **container monitoring**.

---

### Task 3: Set Up Grafana
Grafana is the visualization layer. It connects to Prometheus (and later Loki) and lets you build dashboards, set alerts, and share views with your team.

Add Grafana to your `docker-compose.yml`:
```yaml
  grafana:
    image: grafana/grafana-enterprise:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    restart: unless-stopped
```

Add the volume at the bottom of your compose file:
```yaml
volumes:
  prometheus_data:
  grafana_data:
```

Restart:
```bash
docker compose up -d
```

Open `http://localhost:3000`. Log in with `admin` / `admin123`.

<img width="1912" height="762" alt="image" src="https://github.com/user-attachments/assets/65cfac20-f2bd-441b-9973-1d257bdd4322" />

**Add Prometheus as a datasource:**
1. Go to Connections > Data Sources > Add data source
2. Select Prometheus
3. Set URL to `http://prometheus:9090` (use the container name, not localhost -- they are on the same Docker network)
4. Click Save & Test -- you should see "Successfully queried the Prometheus API"

---

### Task 4: Build Your First Dashboard
Create a dashboard that shows the health of your system at a glance.

1. Go to Dashboards > New Dashboard > Add Visualization
2. Select Prometheus as the datasource

**Panel 1 -- CPU Usage (Gauge):**
```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```
- Visualization: Gauge
- Title: "CPU Usage %"
- Set thresholds: green < 60, yellow < 80, red >= 80

**Panel 2 -- Memory Usage (Gauge):**
```promql
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```
- Visualization: Gauge
- Title: "Memory Usage %"

**Panel 3 -- Container CPU Usage (Time Series):**
```promql
rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
```
- Visualization: Time series
- Title: "Container CPU Usage"
- Legend: `{{name}}`

**Panel 4 -- Container Memory Usage (Bar Chart):**
```promql
container_memory_usage_bytes{name!=""} / 1024 / 1024
```
- Visualization: Bar chart
- Title: "Container Memory (MB)"
- Legend: `{{name}}`

**Panel 5 -- Disk Usage (Stat):**
```promql
(1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
```
- Visualization: Stat
- Title: "Disk Usage %"

Save the dashboard as "DevOps Observability Overview".

---

### Task 5: Auto-Provision Datasources with YAML
In production, you do not click through the UI to add datasources. You provision them with configuration files so the setup is repeatable.

Create the provisioning directory structure:
```bash
mkdir -p grafana/provisioning/datasources
mkdir -p grafana/provisioning/dashboards
```

Create `grafana/provisioning/datasources/datasources.yml`:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
```

Update the Grafana service in `docker-compose.yml` to mount the provisioning directory:
```yaml
  grafana:
    image: grafana/grafana-enterprise:latest
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    restart: unless-stopped
```

Restart Grafana:
```bash
docker compose up -d grafana
```

Check Connections > Data Sources -- Prometheus should already be there without any manual setup.

**Document:** Why is provisioning datasources via YAML better than configuring them manually through the UI?

---

### Task 6: Import a Community Dashboard
The Grafana community maintains thousands of pre-built dashboards. Import one for Node Exporter:

1. Go to Dashboards > New > Import
2. Enter dashboard ID: **1860** (Node Exporter Full)
3. Select your Prometheus datasource
4. Click Import

Explore the imported dashboard. It has dozens of panels covering CPU, memory, disk, network, and more -- all built on the same Node Exporter metrics you queried manually.

**Try another one:** Import dashboard ID **193** (Docker monitoring via cAdvisor). Select Prometheus as the datasource and explore container-level stats.

**Your full `docker-compose.yml` should now have these services:**
- `prometheus`
- `node-exporter`
- `cadvisor`
- `grafana`
- `notes-app` (from Day 73)

Verify all are running:
```bash
docker compose ps
```

---

## Hints
- Node Exporter metrics start with `node_` -- use this prefix to explore in Prometheus
- cAdvisor metrics start with `container_` -- filter with `{name!=""}` to skip aggregated entries
- Grafana uses `http://prometheus:9090` (container name) not `http://localhost:9090` because containers communicate over Docker's internal network
- If Grafana panels show "No data", check: is the datasource configured? Is the PromQL query valid? Try the same query in Prometheus UI first
- Dashboard ID 1860 is the gold standard Node Exporter dashboard -- almost every team uses it
- On macOS with Docker Desktop, some Node Exporter metrics may be limited because Docker runs in a Linux VM, not directly on the host
- Reference repo: https://github.com/LondheShubham153/observability-for-devops -- check `grafana/provisioning/` for provisioning examples

---

## Documentation
Create `day-74-exporters-grafana.md` with:
- Your updated `docker-compose.yml` and `prometheus.yml` with all services
- Difference between Node Exporter and cAdvisor (when to use which)
- Screenshot of Prometheus Targets page with all 3+ targets UP
- Screenshot of your custom Grafana dashboard
- Screenshot of the imported Node Exporter Full dashboard (ID 1860)
- PromQL queries for CPU, memory, disk, and container metrics
- How datasource provisioning works via YAML

---

## Submission
1. Add `day-74-exporters-grafana.md` to `2026/day-74/`
2. Commit and push to your fork

---

## Learn in Public
Share on LinkedIn: "Added Node Exporter for host metrics and cAdvisor for container metrics to my observability stack. Built my first Grafana dashboard from scratch -- CPU, memory, disk, and per-container resource usage all in one view. Imported the community Node Exporter dashboard (ID 1860) and it is packed with insights."

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
