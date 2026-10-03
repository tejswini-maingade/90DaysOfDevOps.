# Day 51 – Kubernetes Manifests and Your First Pods

## Task
Yesterday you set up a cluster. Today you actually deploy something. You will learn the structure of a Kubernetes manifest file and use it to create Pods — the smallest deployable unit in Kubernetes. By the end of today, you should be able to write a Pod definition from scratch without looking at docs.

---

## The Anatomy of a Kubernetes Manifest

Every Kubernetes resource is defined using a YAML manifest with four required top-level fields:

```yaml
apiVersion: v1          # Which API version to use
kind: Pod               # What type of resource
metadata:               # Name, labels, namespace
  name: my-pod
  labels:
    app: my-app
spec:                   # The actual specification (what you want)
  containers:
  - name: my-container
    image: nginx:latest
    ports:
    - containerPort: 80
```

- `apiVersion` — tells Kubernetes which API group to use. For Pods, it is `v1`.
- `kind` — the resource type. Today it is `Pod`. Later you will use `Deployment`, `Service`, etc.
- `metadata` — the identity of your resource. `name` is required. `labels` are key-value pairs used for organization and selection.
- `spec` — the desired state. For a Pod, this means which containers to run, which images, which ports, etc.

---

## Challenge Tasks

### Task 1: Create Your First Pod (Nginx)
Create a file called `nginx-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

Apply it:
```bash
kubectl apply -f nginx-pod.yaml
```

Verify:
```bash
kubectl get pods
kubectl get pods -o wide
```
Wait until the STATUS shows `Running`. Then explore:

# Detailed info about the pod
kubectl describe pod nginx-pod

<img width="1881" height="654" alt="Screenshot 2026-10-03 215016" src="https://github.com/user-attachments/assets/07914958-633e-4d35-b078-225827cd97f1" />
- It shows pod metadata, node & network info,container details,readiness/status,mounted volumes, scheduling constraints, and lifecycle events.

# Read the logs
kubectl logs nginx-pod

- It shows the container’s initialization,configuration steps and Nginx startup logs.

<img width="1506" height="393" alt="Screenshot 2026-10-03 215107" src="https://github.com/user-attachments/assets/ab946c25-5fc3-454b-9787-6ce04196a2e4" />

# Get a shell inside the container
kubectl exec -it nginx-pod -- /bin/bash

# Inside the container, run:
curl localhost:80
exit

**Verify:** Can you see the Nginx welcome page when you curl from inside the pod?

- Yes i can see Nginx welcome page inside pod

<img width="1506" height="679" alt="Screenshot 2026-10-03 215122" src="https://github.com/user-attachments/assets/f1ffb755-09fc-4405-acf0-7846af4128c7" />

---

### Task 2: Create a Custom Pod (BusyBox)
Write a new manifest `busybox-pod.yaml` from scratch (do not copy-paste the nginx one):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox-pod
  labels:
    app: busybox
    environment: dev
spec:
  containers:
  - name: busybox
    image: busybox:latest
    command: ["sh", "-c", "echo Hello from BusyBox && sleep 3600"]
```

Apply and verify:
```bash
kubectl apply -f busybox-pod.yaml
kubectl get pods
kubectl logs busybox-pod
```

Notice the `command` field — BusyBox does not run a long-lived server like Nginx. Without a command that keeps it running, the container would exit immediately and the pod would go into `CrashLoopBackOff`.

**Verify:** Can you see "Hello from BusyBox" in the logs?

- Yes,
<img width="1607" height="294" alt="Screenshot 2026-10-03 215311" src="https://github.com/user-attachments/assets/308659f4-76f1-4927-86b0-7f446fbd8a5c" />


---

### Task 3: Imperative vs Declarative
You have been using the declarative approach (writing YAML, then `kubectl apply`). Kubernetes also supports imperative commands:

```bash
# Create a pod without a YAML file
kubectl run redis-pod --image=redis:latest

# Check it
kubectl get pods
```

Now extract the YAML that Kubernetes generated:
```bash
kubectl get pod redis-pod -o yaml
```

Compare this output with your hand-written manifests. Notice how much extra metadata Kubernetes adds automatically (status, timestamps, uid, resource version).

You can also use dry-run to generate YAML without creating anything:
```bash
kubectl run test-pod --image=nginx --dry-run=client -o yaml
```

This is a powerful trick — use it to quickly scaffold a manifest, then customize it.

**Verify:** Save the dry-run output to a file and compare its structure with your nginx-pod.yaml. What fields are the same? What is different?


<img width="1330" height="423" alt="Screenshot 2026-10-03 215424" src="https://github.com/user-attachments/assets/b9f4f1e3-ccc6-4c13-92d8-4b8a2614beec" />
<img width="1641" height="388" alt="Screenshot 2026-10-03 215554" src="https://github.com/user-attachments/assets/dc652e6d-638f-405f-825e-2182c0384d0e" />


**Same fields:**
- apiVersion: v1
- kind: Pod
- metadata.name: nginx-pod
- metadata.labels.app: nginx
- spec.containers[0].name: nginx
- spec.containers[0].image: nginx:latest
- spec.containers[0].ports[0].containerPort: 80

**Different fields:**
- metadata.annotations
- creationTimestamp
- uid
- resourceVersion
- namespace
- spec.containers[0].imagePullPolicy
- resources
- terminationMessagePath/Policy
- volumeMounts
- spec.dnsPolicy
- restartPolicy
- enableServiceLinks
- nodeName
- schedulerName
- serviceAccount
- terminationGracePeriodSeconds
- tolerations
- volumesstatus

**Imperative (`kubectl run`)**

1. Creates resources immediately with a command.
2. Quick and good for testing;not stored as a file.

**Declarative (`kubectl apply -f`)**

1. Uses a YAML file to define desired state.
2. Versionable,repeatable,and preferred for production.

---

### Task 4: Validate Before Applying
Before applying a manifest, you can validate it:

```bash
# Check if the YAML is valid without actually creating the resource
kubectl apply -f nginx-pod.yaml --dry-run=client

# Validate against the cluster's API (server-side validation)
kubectl apply -f nginx-pod.yaml --dry-run=server
```

Now intentionally break your YAML (remove the `image` field or add an invalid field) and run dry-run again. See what error you get.

**Verify:** What error does Kubernetes give when the image field is missing?

- error getting - pod/nginx-pod unchanged (server dry run)

<img width="1236" height="119" alt="Screenshot 2026-10-03 215729" src="https://github.com/user-attachments/assets/a0d4620b-3400-4203-a958-3803369dd0e8" />


---

### Task 5: Pod Labels and Filtering
Labels are how Kubernetes organizes and selects resources. You added labels in your manifests — now use them:

```bash
# List all pods with their labels
kubectl get pods --show-labels

# Filter pods by label
kubectl get pods -l app=nginx
kubectl get pods -l environment=dev

# Add a label to an existing pod
kubectl label pod nginx-pod environment=production

# Verify
kubectl get pods --show-labels

# Remove a label
kubectl label pod nginx-pod environment-
```

Write a manifest for a third pod with at least 3 labels (app, environment, team). Apply it and practice filtering.
<img width="1919" height="735" alt="Screenshot 2026-10-03 220121" src="https://github.com/user-attachments/assets/565ec774-5afa-4a0a-a640-3545aa2415b3" />
<img width="1479" height="357" alt="Screenshot 2026-10-03 220251" src="https://github.com/user-attachments/assets/2301e400-0ebf-4549-a1f5-a49d4229d527" />


---

### Task 6: Clean Up
Delete all the pods you created:

```bash
# Delete by name
kubectl delete pod nginx-pod
kubectl delete pod busybox-pod
kubectl delete pod redis-pod

# Or delete using the manifest file
kubectl delete -f nginx-pod.yaml

# Verify everything is gone
kubectl get pods
```

<img width="960" height="293" alt="Screenshot 2026-10-03 220821" src="https://github.com/user-attachments/assets/8fd22011-71ee-4183-93c9-4528e18a292b" />



Notice that when you delete a standalone Pod, it is gone forever. There is no controller to recreate it. This is why in production you use Deployments (coming on Day 52) instead of bare Pods.

---

## Hints
- `kubectl apply -f` creates or updates a resource from a file
- `kubectl get pods -o wide` shows the node and IP address
- `kubectl describe pod <name>` shows events — very useful for debugging
- `kubectl logs <name>` shows container stdout/stderr
- `kubectl exec -it <name> -- /bin/sh` gives you a shell (use `/bin/sh` if `/bin/bash` is not available)
- Labels are just key-value pairs — they have no meaning to Kubernetes itself, only to selectors
- `--dry-run=client -o yaml` is your best friend for generating manifest templates

---

- What happens when you delete a standalone Pod?

- when you delete a standalone Pod, it is gone forever. There is no controller to recreate it.
This is why in production you use Deployments instead of bare Pods.

---

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
