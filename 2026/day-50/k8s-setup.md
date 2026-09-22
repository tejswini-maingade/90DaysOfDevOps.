# Day 50 – Kubernetes Architecture and Cluster Setup

## Task
You have been building and shipping containers with Docker. But what happens when you need to run hundreds of containers across multiple servers? You need an orchestrator. Today you start your Kubernetes journey — understand the architecture, set up a local cluster, and run your first `kubectl` commands.

This is where things get real.

---

## Challenge Tasks

### Task 1: Recall the Kubernetes Story
Before touching a terminal, write down from memory:

1. Why was Kubernetes created? What problem does it solve that Docker alone cannot?
- Kubernetes was created by Google to automate the management, scaling, and deployment of containerized applications across clusters of servers, solving the problem of coordination and management at scale that Docker alone cannot handle.

- Docker allows to build and run containers,but it mainly focuses on running containers on a single machine.
- When applications grow and require many containers running across multiple servers, managing them manually becomes difficult. Tasks like scaling containers, restarting failed ones
- Kubernetes solves these issues by acting as a container orchestration system, which can automatically:
    - Scale containers based on demand
    - Restart containers when they fail
    - Manage and schedule containers across multiple machines
- In short, Docker runs containers, while Kubernetes manages large numbers of containers across a cluster of servers.

2. Who created Kubernetes and what was it inspired by?
- Google introduced **Kubernetes** in 2014.
- The project was inspired by Borg, an internal system used by Google to manage containers at massive scale.
- Borg could automatically handle tasks such as scaling and restarting containers.
- Google later released Kubernetes as an open-source project.
- Today it is maintained by the (CNCF) Cloud Native Computing Foundation, which is part of the Linux Foundation.

3. What does the name "Kubernetes" mean?
- The name Kubernetes comes from a Greek word meaning “helmsman” or “ship pilot.” It refers to someone who steers a ship.
- This name reflects the role of Kubernetes, which guides and manages containers, similar to how a helmsman controls a ship.
- Kubernetes is often shortened to **K8s**, where the number 8 represents the eight letters between K and S.

---

### Task 2: Draw the Kubernetes Architecture
From memory, draw or describe the Kubernetes architecture. Your diagram should include:

**Control Plane (Master Node):**
- API Server — the front door to the cluster, every command goes through it
- etcd — the database that stores all cluster state
- Scheduler — decides which node a new pod should run on
- Controller Manager — watches the cluster and makes sure the desired state matches reality

**Worker Node:**
- kubelet — the agent on each node that talks to the API server and manages pods
- kube-proxy — handles networking rules so pods can communicate
- Container Runtime — the engine that actually runs containers (containerd, CRI-O)

<img width="1312" height="1199" alt="ChatGPT Image Sep 19, 2026, 09_00_40 PM" src="https://github.com/user-attachments/assets/13ddc930-4de1-478a-9799-551fbf4db9e6" />



After drawing, verify your understanding:
- What happens when you run `kubectl apply -f pod.yaml`? Trace the request through each component.

  1. kubectl reads the pod.yaml file.
  2. The request is sent to the Kubernetes API Server.
  3. API Server performs: Authentication, Authorization
  4. If valid, the Pod object is stored in etcd.
  5. The Kubernetes Scheduler detects the unscheduled Pod and assigns it to a node.
  6. The kubelet on that node sees the Pod and instructs the container runtime (e.g., containerd) to start the container.
  7. The container starts and the Pod status is updated to Running in the API Server.

- What happens if the API server goes down?
  - You cannot run kubectl commands or make changes to the cluster.
  - Running pods and services continue working, but no new deployments or scheduling happen.

- What happens if a worker node goes down?
  - Pods on that node stop running.
  - Kubernetes detects the failure and reschedules those pods on other healthy nodes.
    
---

### Task 3: Install kubectl
`kubectl` is the CLI tool you will use to talk to your Kubernetes cluster.

Install it:
```bash
# macOS
brew install kubectl

# Linux (amd64)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Windows (with chocolatey)
choco install kubernetes-cli
```

Verify:
```bash
kubectl version --client
```
<img width="1059" height="95" alt="Screenshot 2026-09-22 141113" src="https://github.com/user-attachments/assets/753aee65-8737-42b0-854b-a3d607bbf3b2" />


---

### Task 4: Set Up Your Local Cluster
Choose **one** of the following. Both give you a fully functional Kubernetes cluster on your machine.

**Option A: kind (Kubernetes in Docker)**
```bash
# Install kind
# macOS
brew install kind

# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create a cluster
kind create cluster --name devops-cluster

# Verify
kubectl cluster-info
kubectl get nodes
```
<img width="1221" height="513" alt="Screenshot 2026-09-22 141337" src="https://github.com/user-attachments/assets/0c48a00c-4263-498e-86b9-475de94c501b" />


- The cluster initialized successfully, and the control plane node became Ready.

Cluster endpoint: (https://127.0.0.1:57030)
Node name: cluster-control-plane
Role: control-plane
Kubernetes version:  v1.35.0

Write down: Which one did you choose and why?
- I chose **KIND (Kubernetes IN Docker)** because it is lightweight and easy to set up for local testing. 
- It runs a **Kubernetes** Cluster inside Docker containers, so I can quickly create & delete clusters without needing VMs or a cloud environment.
- This makes it ideal for **development, CI testing, and experimenting with Kubernetes features**.

---

### Task 5: Explore Your Cluster
Now that your cluster is running, explore it:

```bash
# See cluster info
kubectl cluster-info

# List all nodes
kubectl get nodes

# Get detailed info about your node
kubectl describe node <node-name>

<img width="1237" height="702" alt="image" src="https://github.com/user-attachments/assets/e4ec8c9f-d296-4ee9-8f65-2ca3421c5e54" />

- This kubectl command in Kubernetes shows detailed information about the node devops-cluster-control-plane, including its status,resources,conditions,running pods and events.

# List all namespaces
kubectl get namespaces

<img width="702" height="166" alt="image" src="https://github.com/user-attachments/assets/af70447e-d8bb-45fa-83a2-fed5d56aa49d" />

# See ALL pods running in the cluster (across all namespaces)
kubectl get pods -A
```
<img width="1449" height="274" alt="Screenshot 2026-09-22 141543" src="https://github.com/user-attachments/assets/ce781934-8bab-4232-8200-27c4f71d3d15" />

Look at the pods running in the `kube-system` namespace:
```bash
kubectl get pods -n kube-system
```
<img width="1225" height="254" alt="Screenshot 2026-09-22 141603" src="https://github.com/user-attachments/assets/7eb30f51-c9af-4b57-b226-25f197a5390e" />

kube-system Contains core Kubernetes system components such as:

- CoreDNS – cluster DNS service
   - etcd – cluster key-value database
   - kube-apiserver – API server for the cluster
   - kube-controller-manager – manages controllers
   - kube-scheduler – schedules pods to nodes
   - kube-proxy – manages networking rules
   - kindnet – networking plugin

- local-path-storage
   - local-path-provisioner – provides dynamic local storage for pods.

You should see pods like `etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`, `coredns`, and `kube-proxy`. These are the architecture components you drew in Task 2 — running as pods inside the cluster.

**Verify:** Can you match each running pod in `kube-system` to a component in your architecture diagram?

**Status**

- All pods show READY 1/1 and STATUS Running, meaning the cluster components are working correctly.
   - Look at the pods running in the kube-system namespace:

```kubectl get pods -n kube-system```

<img width="1225" height="254" alt="Screenshot 2026-09-22 141603" src="https://github.com/user-attachments/assets/dd9f5676-7a3a-4ad1-8ca9-92ae094eaeb9" />



### Kubernetes System Pods

| Pod Name | Purpose |
|---|---|
| coredns | Provides DNS services so pods can communicate using service names. |
| etcd-devops-cluster-control-plane | Distributed key-value store that holds all cluster configuration and state. |
| kindnet | Networking plugin used by KIND to enable pod networking. |
| kube-apiserver-devops-cluster-control-plane | Main API server that handles all Kubernetes API requests. |
| kube-controller-manager-devops-cluster-control-plane | Runs controllers that manage cluster state such as nodes, replicas, and endpoints. |
| kube-proxy | Manages network rules and enables service networking for pods. |
| kube-scheduler-devops-cluster-control-plane | Assigns newly created pods to available nodes. |

### Status

**READY 1/1**: All containers inside the pod are running.

**STATUS Running**: Pod is functioning correctly.

**RESTARTS 0**: No container crashes occurred.

**AGE 30m**: Pod has been running for 30 minutes.

---

### Task 6: Practice Cluster Lifecycle
Build muscle memory with cluster operations:

```bash
# Delete your cluster
kind delete cluster --name devops-cluster
# (or: minikube delete)

# Recreate it
kind create cluster --name devops-cluster
# (or: minikube start)

# Verify it is back
kubectl get nodes
```
<img width="1013" height="98" alt="Screenshot 2026-09-22 141651" src="https://github.com/user-attachments/assets/d3e022ca-18ff-4392-8bdf-6e44386319ea" />
<img width="1401" height="411" alt="Screenshot 2026-09-22 141751" src="https://github.com/user-attachments/assets/b193fad9-1023-4752-8408-c1511b943f7c" />


Try these useful commands:
```bash
# Check which cluster kubectl is connected to
kubectl config current-context

# List all available contexts (clusters)
kubectl config get-contexts

# See the full kubeconfig
kubectl config view
```
<img width="1919" height="621" alt="Screenshot 2026-09-22 141848" src="https://github.com/user-attachments/assets/b4b9fa63-3b71-45b7-aeb7-019272d0e7ea" />


Write down: What is a kubeconfig? Where is it stored on your machine?
- kubeconfig is a configuration file used by Kubernetes clients kubectl to connect to a Kubernetes cluster.
- It stores cluster details, user credentials, and contexts.
- Location: ~/.kube/config

- `-o wide` flag gives extra details: `kubectl get nodes -o wide`
- 
---

## Hints
- kind requires Docker to be running (it creates clusters using containers)
- minikube can use Docker, VirtualBox, or other drivers
- The default kubeconfig file is at `~/.kube/config`
- `kubectl get pods -A` is short for `kubectl get pods --all-namespaces`
- If `kubectl` cannot connect, check if your cluster is running: `kind get clusters` or `minikube status`

## `-o wide` flag gives extra details: `kubectl get nodes -o wide`

<img width="1919" height="140" alt="Screenshot 2026-09-22 141910" src="https://github.com/user-attachments/assets/0ed209ad-a96b-438c-b372-b7ffb3811848" />


---

Happy Learning!
**TrainWithShubham**
