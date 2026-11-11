# Day 75 -- Log Management with Loki and Promtail

## Task
Metrics tell you _what_ is broken. Logs tell you _why_. Yesterday you built the metrics pipeline with Prometheus, Node Exporter, cAdvisor, and Grafana. Today you add the second pillar of observability -- logs.

You will set up Grafana Loki (a log aggregation system built by the Grafana team) and Promtail (the agent that ships logs to Loki). By the end of today, your Grafana instance will show both metrics and logs side by side.

---

## Challenge Tasks

### Task 1: Understand the Logging Pipeline
Before writing any config, understand how the pieces fit together:

```
[Docker Containers]
       |
       | (write JSON logs to /var/lib/docker/containers/)
       v
  [Promtail]
       |
       | (reads log files, adds labels, pushes to Loki)
       v
    [Loki]
       |
       | (stores logs, indexes by labels)
       v
   [Grafana]
       |
       | (queries Loki with LogQL, displays logs)
       v
   [You]
```

Key differences from the ELK stack:
- Loki does **not** index the full text of logs -- it only indexes labels (like container name, job, filename)
- This makes Loki much cheaper to run and simpler to operate
- Think of it as "Prometheus, but for logs" -- same label-based approach

**Document:** Why does Loki only index labels instead of full text? What is the trade-off?
- Loki indexes only labels to keep storage and costs low.

- **Benefit**
    - Much cheaper & faster ingestion
    - Uses less storage than full-text indexing

- **Trade-off**
   - Log searches are slower (needs to scan log content)
   - Less powerful than full-text search systems

---

### Task 2: Add Loki to the Stack
Create the Loki configuration file.

```bash
mkdir -p loki
```

Create `loki/loki-config.yml`:
```yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  ring:
    instance_addr: 127.0.0.1
    kvstore:
      store: inmemory
  replication_factor: 1
  path_prefix: /loki

schema_config:
  configs:
    - from: 2020-10-24
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  filesystem:
    directory: /loki/chunks
```

**What this config does:**
- `auth_enabled: false` -- single-tenant mode, no authentication needed
- `store: tsdb` -- uses Loki's time-series database for indexing
- `object_store: filesystem` -- stores log chunks on local disk
- `replication_factor: 1` -- single instance, no replication (fine for learning)

Add Loki to your `docker-compose.yml`:
```yaml
  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    volumes:
      - ./loki/loki-config.yml:/etc/loki/loki-config.yml
      - loki_data:/loki
    command: -config.file=/etc/loki/loki-config.yml
    restart: unless-stopped
```

Add `loki_data` to your volumes section:
```yaml
volumes:
  prometheus_data:
  grafana_data:
  loki_data:
```

Start Loki:
```bash
docker compose up -d loki
```

Verify Loki is running:
```bash
curl http://localhost:3100/ready
```

You should see `ready`.

<img width="766" height="90" alt="image" src="https://github.com/user-attachments/assets/efe7396c-7932-475b-a83b-a257b06b7125" />

---

### Task 3: Add Promtail to Collect Container Logs
Promtail is the log collection agent. It reads Docker container log files from the host and pushes them to Loki.

```bash
mkdir -p promtail
```

Create `promtail/promtail-config.yml`:
```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          __path__: /var/lib/docker/containers/*/*-json.log
    pipeline_stages:
      - docker: {}
```

**What this config does:**
- `positions` -- tracks which log lines have already been shipped (like a bookmark)
- `clients` -- where to send logs (Loki endpoint)
- `__path__` -- the glob pattern to find Docker JSON log files on the host
- `pipeline_stages: docker: {}` -- parses the Docker JSON log format and extracts timestamp, stream (stdout/stderr), and the log message

Add Promtail to your `docker-compose.yml`:
```yaml
  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    volumes:
      - ./promtail/promtail-config.yml:/etc/promtail/promtail-config.yml
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock
    command: -config.file=/etc/promtail/promtail-config.yml
    restart: unless-stopped
```

**Why these volume mounts?**
- `/var/lib/docker/containers` -- where Docker stores container log files (read-only)
- `/var/run/docker.sock` -- lets Promtail discover container metadata (names, labels)

Restart the stack:
```bash
docker compose up -d
```

Generate some logs by hitting the notes app:
```bash
for i in $(seq 1 20); do curl -s http://localhost:8000 > /dev/null; done
```

---

### Task 4: Add Loki as a Grafana Datasource
You can add it manually through the UI or auto-provision it with YAML.

**Option A -- Provision via YAML (recommended):**

Update `grafana/provisioning/datasources/datasources.yml`:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    editable: false
```

Restart Grafana to pick up the new datasource:
```bash
docker compose restart grafana
```

**Option B -- Manual UI setup:**
1. Go to Connections > Data Sources > Add data source
2. Select Loki
3. URL: `http://loki:3100`
4. Save & Test

Either way, you should now have two datasources in Grafana: Prometheus and Loki.

<img width="902" height="469" alt="image" src="https://github.com/user-attachments/assets/16ad9f95-b3ab-4dc5-b3a4-9bd1ea5eb272" />

---

### Task 5: Query Logs with LogQL
LogQL is Loki's query language -- similar to PromQL but for logs.

Go to Grafana > Explore (compass icon). Select Loki as the datasource.

1. **Stream selector** -- filter logs by labels:
```logql
{job="docker"}
```
This shows all Docker container logs.

<img width="1005" height="562" alt="image" src="https://github.com/user-attachments/assets/450cd966-1a52-44cc-a6ce-45cf48130f54" />

2. **Filter by container name:**
```logql
{container_name="prometheus"}
```

<img width="1006" height="602" alt="image" src="https://github.com/user-attachments/assets/a0f6a6df-7ac8-4efd-a1e7-f98c7ae8e21c" />

3. **Keyword search** -- filter log lines by content:
```logql
{job="docker"} |= "error"
```
`|=` means "line contains". This finds all log lines with the word "error".

<img width="1012" height="617" alt="image" src="https://github.com/user-attachments/assets/aeb94aae-85d0-484a-a3df-9f84f38ddb25" />

4. **Negative filter:**
```logql
{job="docker"} != "health"
```
Excludes lines containing "health" (useful to filter out health check noise).

<img width="986" height="622" alt="image" src="https://github.com/user-attachments/assets/a22dd013-b7ac-4fca-9d39-d1bd0dd4a271" />

5. **Regex filter:**
```logql
{job="docker"} |~ "status=[45]\\d{2}"
```
Finds lines with HTTP 4xx or 5xx status codes.

<img width="1013" height="614" alt="image" src="https://github.com/user-attachments/assets/1f2e92dd-134c-41fb-9023-2361a7981083" />

6. **Log metric queries** -- count log lines over time:
```logql
count_over_time({job="docker"}[5m])
```

<img width="1009" height="450" alt="image" src="https://github.com/user-attachments/assets/666b3645-8652-4f7a-8e70-6d6fd7461ea1" />

7. **Rate of logs per second:**
```logql
rate({job="docker"}[5m])
```

<img width="1010" height="492" alt="image" src="https://github.com/user-attachments/assets/2a1cefa7-7051-4dc2-9c45-9058cbf62958" />

8. **Top containers by log volume:**
```logql
topk(5, sum by (container_name) (rate({job="docker"}[5m])))
```

<img width="1006" height="518" alt="image" src="https://github.com/user-attachments/assets/1b5e0cb4-2d77-4e3f-9b6b-fb2175b3ad70" />

**Exercise:** Write a LogQL query that finds all error logs from the notes-app container in the last 1 hour. Then write another query that counts how many error lines per minute.

- ```{container_name="notes-app"} |~ "(?i)error|404|exception"```
<img width="976" height="586" alt="image" src="https://github.com/user-attachments/assets/dc86c2e8-3a0c-4114-bfcc-47d5defcda7e" />

- ```count_over_time({container_name="notes-app"} |~ "(?i)error|404|exception"[1m])```
<img width="1010" height="586" alt="image" src="https://github.com/user-attachments/assets/70127190-ee82-4ca2-895d-3e31f78f101f" />

---

### Task 6: Correlate Metrics and Logs in Grafana
The real power of observability is correlation -- seeing metrics and logs together.

1. **Add a logs panel to your dashboard:**
   - Open the dashboard you built on Day 74
   - Add a new panel
   - Select Loki as the datasource
   - Query: `{job="docker"}`
   - Visualization: Logs
   - Title: "Container Logs"

<img width="1010" height="396" alt="image" src="https://github.com/user-attachments/assets/dec1289d-70e2-434e-8204-c2c19dea4cb4" />

2. **Use the Explore split view:**
   - Go to Explore
   - Click the split button (two panels side by side)
   - Left panel: Prometheus -- `rate(container_cpu_usage_seconds_total{name="notes-app"}[5m])`
   - Right panel: Loki -- `{container_name="notes-app"}`
   - Now you can see CPU spikes and the corresponding log output at the same time

<img width="978" height="398" alt="image" src="https://github.com/user-attachments/assets/d865db68-22ca-4221-8ad4-586094a9bf87" />

3. **Time sync:** Click on a spike in the metrics graph and both panels will zoom to that time range. This is how you debug in production -- you see a metric anomaly and immediately check the logs from that exact moment.

**Document:** How does having metrics and logs in the same tool (Grafana) help during incident response compared to checking separate systems?

- Having metrics and logs in the same tool helps because you can quickly go from seeing a problem in metrics to checking the related logs without switching systems.

- This makes troubleshooting faster during incidents.

- **Comparison: Loki vs ELK stack (when would you use each?)**

**Loki vs ELK:**

* **Loki** → best for **cheap, simple, high-volume logging** tied to services (works great with Grafana/Prometheus). Limited full-text search, relies on labels.
* **ELK stack (Elasticsearch + Logstash + Kibana)** → best for **powerful full-text search, deep log analysis, and security/audit use cases**, but heavier and more expensive to run.

---

Happy Learning!
**TrainWithShubham**
