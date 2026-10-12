# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)

## Task
Yesterday you set resource requests and limits. Today you put that to work. Install the Metrics Server so Kubernetes can see actual resource usage, then set up a Horizontal Pod Autoscaler that scales your app up under load and back down when things calm down.

---

## Challenge Tasks

### Task 1: Install the Metrics Server
1. Check if it is already running: `kubectl get pods -n kube-system | grep metrics-server`
2. If not, install it:
   - Minikube: `minikube addons enable metrics-server`
   - Kind/kubeadm: apply the official manifest from the metrics-server GitHub releases
3. On local clusters, you may need the `--kubelet-insecure-tls` flag (never in production)
4. Wait 60 seconds, then verify: `kubectl top nodes` and `kubectl top pods -A`

**Verify:** What is the current CPU and memory usage of your node?

- Current node utilization is low: CPU usage is 0–2% and memory usage is 2–8% across nodes.

- Here is the correct, up-to-date URL to deploy the Metrics Server:- kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

1. The Patch Command

`
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
`
<img width="1519" height="600" alt="Screenshot 2026-10-12 110715" src="https://github.com/user-attachments/assets/a1a8c38a-f016-44ac-aa5f-27fdef4fba91" />


---

### Task 2: Explore kubectl top
1. Run `kubectl top nodes`, `kubectl top pods -A`, `kubectl top pods -A --sort-by=cpu`
2. `kubectl top` shows real-time usage, not requests or limits — these are different things
3. Data comes from the Metrics Server, which polls kubelets every 15 seconds

**Verify:** Which pod is using the most CPU right now?

- `kube-apiserver-devops-cluster-control-plane` Pod using the most CPU

<img width="1919" height="692" alt="Screenshot 2026-10-12 111106" src="https://github.com/user-attachments/assets/2146237d-243d-4d31-bdd8-267f675dca1c" />


---

### Task 3: Create a Deployment with CPU Requests
1. Write a Deployment manifest using the `registry.k8s.io/hpa-example` image (a CPU-intensive PHP-Apache server)
2. Set `resources.requests.cpu: 200m` — HPA needs this to calculate utilization percentages
3. Expose it as a Service: `kubectl expose deployment php-apache --port=80`

Without CPU requests, HPA cannot work — this is the most common HPA setup mistake.

**Verify:** What is the current CPU usage of the Pod?

- Current CPU Usage is: 1m

<img width="1919" height="539" alt="Screenshot 2026-10-12 111319" src="https://github.com/user-attachments/assets/5fc37e4b-5cf5-4e3c-bac5-5e49559848cd" />


---

### Task 4: Create an HPA (Imperative)
1. Run: `kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10`
2. Check: `kubectl get hpa` and `kubectl describe hpa php-apache`
3. TARGETS may show `<unknown>` initially — wait 30 seconds for metrics to arrive

This scales up when average CPU exceeds 50% of requests, and down when it drops below.

**Verify:** What does the TARGETS column show?

- `TARGETS column show:` current usage (1m) vs desired target(50m)

<img width="1800" height="296" alt="Screenshot 2026-10-12 111357" src="https://github.com/user-attachments/assets/fb31123f-e35d-45ec-867e-7ce8d8f0230a" />

---

### Task 5: Generate Load and Watch Autoscaling
1. Start a load generator: `kubectl run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"`
2. Watch HPA: `kubectl get hpa php-apache --watch`
3. Over 1-3 minutes, CPU climbs above 50%, replicas increase, CPU stabilizes
4. Stop the load: `kubectl delete pod load-generator`
5. Scale-down is slow (5-minute stabilization window) — you do not need to wait

**Verify:** How many replicas did HPA scale to under load?

- It scaled to max=10 replicas under load.
<img width="1919" height="403" alt="Screenshot 2026-10-12 111621" src="https://github.com/user-attachments/assets/3ee0a51f-e5fa-4820-a7c0-6ffd6606f7e7" />



- After load removed

<img width="1196" height="261" alt="Screenshot 2026-10-12 111819" src="https://github.com/user-attachments/assets/bb82d3fb-cf29-43b2-8166-9bb9b9d8dc74" />


---

### Task 6: Create an HPA from YAML (Declarative)
1. Delete the imperative HPA: `kubectl delete hpa php-apache`
2. Write an HPA manifest using `autoscaling/v2` API with CPU target at 50% utilization
3. Add a `behavior` section to control scale-up speed (no stabilization) and scale-down speed (300 second window)
4. Apply and verify with `kubectl describe hpa`

`autoscaling/v2` supports multiple metrics and fine-grained scaling behavior that the imperative command cannot configure.

**Verify:** What does the `behavior` section control?

- The behavior section controls how the HPA scales pods up and down.
- `Stabilization window:` how long to wait before scaling up or down
- `Policies:` limit how many pods can be added or removed
- `Percent:` scale based on percentage
- `Pods:` scale by a fixed number
- `periodSeconds:` minimum time between scaling actions

<img width="1919" height="672" alt="Screenshot 2026-10-12 112027" src="https://github.com/user-attachments/assets/5e03ee98-2186-4394-8204-0ac5fa369ca3" />


---

### Task 7: Clean Up
Delete the HPA, Service, Deployment, and load-generator pod. Leave the Metrics Server installed.

<img width="967" height="415" alt="Screenshot 2026-10-12 112156" src="https://github.com/user-attachments/assets/6c2b73b9-5861-4bdd-9975-f92a79396706" />

---

**What the Metrics Server is and why HPA needs it**

- Metrics Server collects real-time CPU and memory usage from nodes and pods.
- HPA uses this data to decide when to scale pods up or down based on actual resource usage.

**How HPA calculates desired replicas**

- desiredReplicas = ceil(currentReplicas * (currentUsage / targetUsage))

**The difference between `autoscaling/v1` and `v2`**

`autoscaling/v1`
- Supports only CPU-based scaling
- Basic configuration

`autoscaling/v2`
- Supports multiple metrics (CPU,memory,custom)
- Advanced behavior control (scale-up/down rules)

---

Happy Learning!
**TrainWithShubham**
