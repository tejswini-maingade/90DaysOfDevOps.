# Day 56 – Kubernetes StatefulSets

## Task
Deployments work great for stateless apps, but what about databases? You need stable pod names, ordered startup, and persistent storage per replica. Today you learn StatefulSets — the workload designed for stateful applications like MySQL, PostgreSQL, and Kafka.

---

## Challenge Tasks 

### Task 1: Understand the Problem
1. Create a Deployment with 3 replicas using nginx
2. Check the pod names — they are random (`app-xyz-abc`)
3. Delete a pod and notice the replacement gets a different random name

This is fine for web servers but not for databases where you need stable identity.

| Feature | Deployment | StatefulSet |
|---|---|---|
| Pod names | Random | Stable, ordered (`app-0`, `app-1`) |
| Startup order | All at once | Ordered: pod-0, then pod-1, then pod-2 |
| Storage | Shared PVC | Each pod gets its own PVC |
| Network identity | No stable hostname | Stable DNS per pod |

Delete the Deployment before moving on.

**Verify:** Why would random pod names be a problem for a database cluster?

- Random pod names break database clusters because nodes need stable names for connections, replication, and storage.

<img width="1919" height="728" alt="Screenshot 2026-10-10 193924" src="https://github.com/user-attachments/assets/0f18b11e-be95-47b2-b740-0b51091ae65b" />


---

### Task 2: Create a Headless Service
1. Write a Service manifest with `clusterIP: None` — this is a Headless Service
2. Set the selector to match the labels you will use on your StatefulSet pods
3. Apply it and confirm CLUSTER-IP shows `None`

A Headless Service creates individual DNS entries for each pod instead of load-balancing to one IP. StatefulSets require this.

**Verify:** What does the CLUSTER-IP column show?
- CLUSTER_IP Column Show : `None`

<img width="1255" height="571" alt="Screenshot 2026-10-10 194055" src="https://github.com/user-attachments/assets/9c8010b7-7c43-4ead-8746-a0bfb345bf4a" />


---

### Task 3: Create a StatefulSet
1. Write a StatefulSet manifest with `serviceName` pointing to your Headless Service
2. Set replicas to 3, use the nginx image
3. Add a `volumeClaimTemplates` section requesting 100Mi of ReadWriteOnce storage
4. Apply and watch: `kubectl get pods -l <your-label> -w`

Observe ordered creation — `web-0` first, then `web-1` after `web-0` is Ready, then `web-2`.

Check the PVCs: `kubectl get pvc` — you should see `web-data-web-0`, `web-data-web-1`, `web-data-web-2` (names follow the pattern `<template-name>-<pod-name>`).

**Verify:** What are the exact pod names and PVC names?

- Pod names : `web-0` `web-1` `web-2`
- PVC names : `web-data-web-0` `web-data-web-1` `web-data-web-2`

<img width="1495" height="675" alt="Screenshot 2026-10-10 194340" src="https://github.com/user-attachments/assets/c59211a1-c6fc-4826-a703-022b8ac567a5" />
<img width="1510" height="668" alt="Screenshot 2026-10-10 194407" src="https://github.com/user-attachments/assets/dd077f7f-9994-4518-9853-3948fc510d1c" />

---

### Task 4: Stable Network Identity
Each StatefulSet pod gets a DNS name: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`

1. Run a temporary busybox pod and use `nslookup` to resolve `web-0.<your-headless-service>.default.svc.cluster.local`
2. Do the same for `web-1` and `web-2`
3. Confirm the IPs match `kubectl get pods -o wide`

**Verify:** Does the nslookup IP match the pod IP?
- Yes,nslookup IP match the Pod IP 

<img width="1514" height="554" alt="Screenshot 2026-10-10 195222" src="https://github.com/user-attachments/assets/f6802a5a-9cd3-4ac9-bc8f-7f01c8d0c8c0" />


---

### Task 5: Stable Storage — Data Survives Pod Deletion
1. Write unique data to each pod: `kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/html/index.html"`
2. Delete `web-0`: `kubectl delete pod web-0`
3. Wait for it to come back, then check the data — it should still be "Data from web-0"

The new pod reconnected to the same PVC.

**Verify:** Is the data identical after pod recreation?

- Yes,exactly the same
<img width="1745" height="539" alt="Screenshot 2026-10-10 195521" src="https://github.com/user-attachments/assets/45a07e8d-db3e-406a-ad2d-7b75d9ae7591" />


---

### Task 6: Ordered Scaling
1. Scale up to 5: `kubectl scale statefulset web --replicas=5` — pods create in order (web-3, then web-4)
2. Scale down to 3 — pods terminate in reverse order (web-4, then web-3)
3. Check `kubectl get pvc` — all five PVCs still exist. Kubernetes keeps them on scale-down so data is preserved if you scale back up.

**Verify:** After scaling down, how many PVCs exist?

- After scaling down, 5 PVCs exits

<img width="1885" height="721" alt="Screenshot 2026-10-10 195748" src="https://github.com/user-attachments/assets/6d059d7b-08b5-4e01-a083-8b2b12276618" />
<img width="1678" height="525" alt="Screenshot 2026-10-10 195809" src="https://github.com/user-attachments/assets/ed8f0a62-fba0-4d20-886f-576aaf25388b" />


---

### Task 7: Clean Up
1. Delete the StatefulSet and the Headless Service
2. Check `kubectl get pvc` — PVCs are still there (safety feature)
3. Delete PVCs manually

**Verify:** Were PVCs auto-deleted with the StatefulSet?

- PVCs are NOT auto-deleted when a StatefulSet is deleted

<img width="1026" height="339" alt="Screenshot 2026-10-10 200329" src="https://github.com/user-attachments/assets/70e4f83c-59c6-4ad4-a4a1-a4c6a2b994a1" />

---

## Documentation
**What StatefulSets are and when to use them vs Deployments**

`StatefulSet`

- A StatefulSet is used to manage stateful applications where each pod needs:
    - Stable identity (fixed name like web-0)
    - Stable network (DNS)
    - Persistent storage (PVC per pod)
    - Ordered deployment & scaling

- Use StatefulSet when:
   - Running databases (MySQL, PostgreSQL, MongoDB)
   - Distributed systems (Kafka, Zookeeper)
   - Apps needing data persistence + identity

`Deployment`

- A Deployment is used for stateless applications where:
    - Pods are interchangeable
    - No fixed identity needed
    - No persistent storage required

- Use Deployment when:
    - Web apps (frontend, APIs)
    - Microservices

**Comparison Deployment vs StatefulSet**

| Feature | Deployment | StatefulSet |
|---|---|---|
| Pod names | Random | Stable, ordered (`app-0`, `app-1`) |
| Startup order | All at once | Ordered: pod-0, then pod-1, then pod-2 |
| Storage | Shared PVC | Each pod gets its own PVC |
| Network identity | No stable hostname | Stable DNS per pod |

**How Headless Services, stable DNS, and volumeClaimTemplates work**

1. `StatefulSet`
- Creates pods: web-0, web-1, web-2
- Each pod has a fixed identity

2. `Storage (volumeClaimTemplates)`
    - Each pod gets its own PVC:
    - web-0 -> web-data-0
    - web-1 -> web-data-1
    - web-2 -> web-data-2

3. `Headless Service`
- Exposes each pod individually

4. `DNS`
- Each pod gets a stable DNS:

    - web-0.web-headless -> Pod IP
    - web-1.web-headless -> Pod IP
    - web-2.web-headless -> Pod IP

---

## Learn in Public
Share on LinkedIn: "Learned Kubernetes StatefulSets today. Stable pod names, per-pod DNS, and persistent storage that survives deletion — now I understand why databases need StatefulSets."

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
