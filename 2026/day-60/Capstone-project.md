# Kubernetes Audit — E-commerce Application

## Project Overview

This project deploys a three-tier e-commerce application on Kubernetes using:

* React + Nginx — Frontend
* Node.js + Express — Backend
* PostgreSQL — Database
* Docker — Containerization
* Kubernetes — Container orchestration
* KIND — Multi-node Kubernetes cluster
* NGINX Ingress — External access
* GitHub Actions — CI/CD

The following table documents the Kubernetes concepts implemented in this project, the evidence used to verify them, why each concept was used, and where the implementation can be found.

---

## Kubernetes Audit Checklist

| Concept                             | Status | Evidence                                                                          | Why I used it                                                                                                                     | Where to look                                                                                 |
| ----------------------------------- | ------ | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **1. Deployment + ReplicaSet**      | ✅ Done | `kubectl get deployments -n ecommerce` and `kubectl get replicasets -n ecommerce` | Deployments maintain the desired number of application Pods and provide controlled application updates.                           | `k8s/backend/deployment.yaml`, `k8s/frontend/deployment.yaml`, `k8s/database/deployment.yaml` |
| **2. Service**                      | ✅ Done | `kubectl get services -n ecommerce`                                               | Services provide stable networking and service discovery for communication between application components.                        | `k8s/backend/service.yaml`, `k8s/frontend/service.yaml`, `k8s/database/service.yaml`          |
| **3. Namespace**                    | ✅ Done | `kubectl get namespace ecommerce`                                                 | A dedicated namespace isolates all e-commerce application resources from other workloads.                                         | `k8s/namespace.yaml`                                                                          |
| **4. Labels & Selectors**           | ✅ Done | `kubectl get pods -n ecommerce --show-labels`                                     | Labels identify resources and selectors allow Services and Deployments to target the correct Pods.                                | Deployment and Service manifests under `k8s/`                                                 |
| **5. Rolling Update + Rollback**    | ✅ Done | `kubectl rollout history deployment/ecommerce-backend -n ecommerce`               | Rolling updates allow new versions to be deployed gradually with minimal downtime, while rollback provides a recovery mechanism.  | `k8s/backend/deployment.yaml`                                                                 |
| **6. ConfigMap**                    | ✅ Done | `kubectl get configmap -n ecommerce`                                              | ConfigMaps keep non-sensitive application configuration separate from container images and application code.                      | `k8s/backend/configmap.yaml`                                                                  |
| **7. Secret**                       | ✅ Done | `kubectl get secrets -n ecommerce`                                             | Secrets are used to store sensitive database credentials instead of exposing them directly in application configuration.          | `k8s/database/secret.yaml`                                                                    |
| **8. Resource Requests & Limits**   | ❌ Notdone | `kubectl describe pod -n ecommerce`                                            | CPU and memory requests/limits provide predictable resource allocation and prevent a workload from consuming unlimited resources. | Deployment manifests under `k8s/backend/` and `k8s/frontend/`                                 |
| **9. Liveness & Readiness Probes**  | ✅ Done | `kubectl describe pod <pod-name> -n ecommerce`                                    | Probes allow Kubernetes to detect unhealthy containers and prevent traffic from reaching Pods that are not ready.                 | Backend and frontend Deployment manifests                                                     |
| **10. PersistentVolumeClaim (PVC)** | ✅ Done | `kubectl get pvc -n ecommerce`                                                    | A PVC provides persistent storage for PostgreSQL so database data is not tied to the lifetime of a Pod.                           | `k8s/database/pvc.yaml`                                                                       |
| **11. Ingress**                     | ✅ Done | `kubectl get ingress -n ecommerce`                                                | Ingress provides HTTP/HTTPS routing from outside the cluster to the frontend application.                                         | `k8s/ingress.yaml`                                                                            |
| **12. Multi-node Cluster**          | ❌ Notdone | `kubectl get nodes -o wide`                                                    | A multi-node cluster demonstrates Kubernetes scheduling across multiple worker nodes and improves workload distribution.          | `kind/kind-config.yaml`                                                                       |
| **13. HPA**                         | ✅ Done | `kubectl get hpa -n ecommerce`                                                    | Horizontal Pod Autoscaler automatically adjusts backend replicas based on resource utilization.                                   | `k8s/backend/hpa.yaml`                                                                        |
| **14. RBAC + ServiceAccount**       | ✅ Done | `kubectl get serviceaccount,role,rolebinding -n ecommerce`                        | RBAC follows the principle of least privilege by giving workloads only the Kubernetes permissions they need.                      | `k8s/rbac/`                                                                                   |
| **15. CronJob**                     | ✅ Done | `kubectl get cronjobs -n ecommerce`                                               | CronJob demonstrates scheduled Kubernetes workloads for periodic maintenance or health-check tasks.                               | `k8s/cronjob.yaml`                                                                            |
| **16. GitHub Actions**              | ✅ Done | GitHub Actions workflow execution                                                 | GitHub Actions automates the build and Kubernetes deployment/validation process.                                                  | `.github/workflows/`                                                                          |

---

# Detailed Evidence

## 1. Deployment + ReplicaSet

### Evidence

```bash
kubectl get deployments -n ecommerce
kubectl get replicasets -n ecommerce
kubectl get pods -n ecommerce
```
<img width="1204" height="364" alt="Screenshot 2026-10-07 211124" src="https://github.com/user-attachments/assets/1b1b51bd-57b1-4cec-a6ae-bb5ba57cdff9" />

### Expected

You should see Deployments for the frontend, backend and database workloads, along with ReplicaSets created by the Deployments.

### Why

Deployments provide declarative application management and automatically create ReplicaSets to maintain the desired number of Pods.

### Where to look

```text
k8s/backend/deployment.yaml
k8s/frontend/deployment.yaml
k8s/database/deployment.yaml
```

---

## 2. Service

### Evidence

```bash
kubectl get services -n ecommerce
```

<img width="915" height="158" alt="Screenshot 2026-10-07 220352" src="https://github.com/user-attachments/assets/e02dc2d6-025f-4958-aa36-0a372bb0b3f0" />

### Why

Services provide stable DNS names and networking between the frontend, backend and database.

For example:

```text
frontend
backend
postgres
```

### Where to look

```text
k8s/frontend/service.yaml
k8s/backend/service.yaml
k8s/database/service.yaml
```

---

## 3. Namespace

### Evidence

```bash
kubectl get namespace ecommerce
```
<img width="908" height="103" alt="Screenshot 2026-10-07 220440" src="https://github.com/user-attachments/assets/9b4cd11f-3ee8-4b58-8249-196dbf77ac41" />

### Why

The `ecommerce` namespace provides logical isolation for all application resources.

### Where to look

```text
k8s/namespace.yaml
```

---

## 4. Labels & Selectors

### Evidence

```bash
kubectl get pods -n ecommerce --show-labels
```
<img width="1898" height="353" alt="Screenshot 2026-10-07 220534" src="https://github.com/user-attachments/assets/b1c5bbf0-0c39-4966-b2a3-7e129e787a1b" />

Also:

```bash
kubectl get services -n ecommerce -o yaml
```
<img width="1905" height="776" alt="Screenshot 2026-10-07 220644" src="https://github.com/user-attachments/assets/2f899f37-6dd6-4101-b279-abbdd9731c65" />

### Why

Labels identify workloads while selectors allow Services and Deployments to find the correct Pods.

Example:

```yaml
labels:
  app: ecommerce-backend
```

and:

```yaml
selector:
  app: ecommerce-backend
```

### Where to look

```text
k8s/backend/deployment.yaml
k8s/backend/service.yaml
k8s/frontend/deployment.yaml
k8s/frontend/service.yaml
```

---

## 5. Rolling Update + Rollback

### Evidence

```bash
kubectl rollout status deployment/ecommerce-backend -n ecommerce
kubectl rollout history deployment/ecommerce-backend -n ecommerce
```

Rollback command:

```bash
kubectl rollout undo deployment/ecommerce-backend -n ecommerce
```
<img width="1292" height="118" alt="Screenshot 2026-10-07 220750" src="https://github.com/user-attachments/assets/06250bf1-0ed2-4887-b394-523dca5fe8d2" />

### Why

Rolling updates allow application versions to change without taking the entire application offline. Rollback provides a quick recovery mechanism if the new version causes problems.

### Where to look

```text
k8s/backend/deployment.yaml
```

---

## 6. ConfigMap

### Evidence

```bash
kubectl get configmaps -n ecommerce
kubectl describe configmap ecommerce-backend-config -n ecommerce
```
<img width="1919" height="729" alt="Screenshot 2026-10-07 221117" src="https://github.com/user-attachments/assets/4933d75f-b842-4a09-be89-526100ebf317" />

### Why

ConfigMap stores non-sensitive configuration separately from application code and container images.

Examples include:

```text
NODE_ENV
PORT
DATABASE_HOST
DATABASE_PORT
DATABASE_NAME
```

### Where to look

```text
k8s/backend/configmap.yaml
```

---

## 7. Secret

### Evidence

```bash
kubectl get secrets -n ecommerce
```

To inspect the Secret structure without exposing values:

```bash
kubectl describe secret ecommerce-db-secret -n ecommerce
```
<img width="1332" height="427" alt="Screenshot 2026-10-07 210453" src="https://github.com/user-attachments/assets/a7f7d4e7-fd58-46dc-a548-8e8dbe061fd9" />

### Why

Database usernames and passwords are sensitive information, so Kubernetes Secrets are used instead of putting credentials directly into the application Deployment.

### Where to look

```text
k8s/database/secret.yaml
```

> Secret values should not be exposed in screenshots, README files, GitHub issues, or public repositories.

---

## 8. Resource Requests & Limits

### Evidence

```bash
kubectl describe pod <backend-pod-name> -n ecommerce
```

Or:

```bash
kubectl get deployment ecommerce-backend -n ecommerce -o yaml
```

### Why

Resource requests help Kubernetes schedule Pods correctly, while limits prevent a container from consuming excessive CPU or memory.

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

### Where to look

```text
k8s/backend/deployment.yaml
k8s/frontend/deployment.yaml
```

---

## 9. Liveness & Readiness Probes

### Evidence

```bash
kubectl describe pod <backend-pod-name> -n ecommerce
```

Look for:

```text
Liveness
Readiness
```

You can also check:

```bash
kubectl get pods -n ecommerce
```

### Why

* **Readiness probe:** Determines whether a Pod is ready to receive traffic.
* **Liveness probe:** Determines whether a container is healthy and needs to be restarted.

### Where to look

```text
k8s/backend/deployment.yaml
k8s/frontend/deployment.yaml
```

---

## 10. PersistentVolumeClaim

### Evidence

```bash
kubectl get pvc -n ecommerce
kubectl get pv
```
<img width="1910" height="215" alt="Screenshot 2026-10-07 221605" src="https://github.com/user-attachments/assets/042617d4-15f8-484e-8555-c0fdaf2e9fd3" />

### Why

PostgreSQL requires persistent storage so database data can survive Pod recreation.

The PVC requests persistent storage from Kubernetes.

### Where to look

```text
k8s/database/pvc.yaml
```

---

## 11. Ingress

### Evidence

```bash
kubectl get ingress -n ecommerce
kubectl describe ingress ecommerce-ingress -n ecommerce
```
<img width="1312" height="405" alt="Screenshot 2026-10-07 221700" src="https://github.com/user-attachments/assets/4a141ee7-cf7f-4171-a440-88b57980620f" />

### Why

Ingress provides external HTTP routing to the application and allows users to access the e-commerce frontend through a hostname.

Example:

```text
ecommerce.localtest.me
```

### Where to look

```text
k8s/ingress.yaml
```

---

## 12. Multi-node Cluster

### Evidence

```bash
kubectl get nodes -o wide
```
<img width="1905" height="344" alt="Screenshot 2026-10-07 203708" src="https://github.com/user-attachments/assets/e83b1deb-ff12-4522-bcf4-216f3284e5d2" />

### Expected

The KIND cluster should contain multiple nodes, for example:

```text
kind-audit-control-plane

```

### Why

A multi-node cluster demonstrates Kubernetes scheduling and workload distribution across multiple nodes.

### Where to look

```text
kind/kind-config.yaml
```

---

## 13. Horizontal Pod Autoscaler

### Evidence

```bash
kubectl get hpa -n ecommerce
```

Detailed information:

```bash
kubectl describe hpa ecommerce-backend-hpa -n ecommerce
```
<img width="1267" height="124" alt="Screenshot 2026-10-07 221846" src="https://github.com/user-attachments/assets/78801d25-7c41-4318-9138-6c1b7eba79ec" />

### Why

HPA automatically increases or decreases backend replicas based on CPU utilization, allowing the application to respond to changing workload.

### Where to look

```text
k8s/backend/hpa.yaml
```

---

## 14. RBAC + ServiceAccount

### Evidence

```bash
kubectl get serviceaccounts -n ecommerce
kubectl get roles -n ecommerce
kubectl get rolebindings -n ecommerce
```
<img width="1200" height="357" alt="Screenshot 2026-10-07 221949" src="https://github.com/user-attachments/assets/ee5ce160-ae65-4530-aec6-492f968cf000" />

### Why

RBAC limits what the application's ServiceAccount can access inside the Kubernetes API, following the principle of least privilege.

### Where to look

```text
k8s/rbac/serviceaccount.yaml
k8s/rbac/role.yaml
k8s/rbac/rolebinding.yaml
```

---

## 15. CronJob

### Evidence

```bash
kubectl get cronjobs -n ecommerce
kubectl get jobs -n ecommerce
```

Detailed information:

```bash
kubectl describe cronjob ecommerce-db-healthcheck -n ecommerce
```

### Why

The CronJob demonstrates how Kubernetes can run scheduled tasks automatically, such as periodic database health checks or maintenance operations.

### Where to look

```text
k8s/cronjob.yaml
```

---

## 16. GitHub Actions

### Evidence

Check the GitHub repository:

```text
Actions → Workflows → Kubernetes CI/CD
```

The workflow should show a successful run.

### Why

GitHub Actions automates application validation and Kubernetes deployment tasks, reducing manual deployment steps and improving consistency.

### Where to look

```text
.github/workflows/
```

---

# Final Verification Commands

Run these commands before submitting the assignment:

```bash
kubectl get all -n ecommerce
```

```bash
kubectl get configmaps,secrets,pvc,hpa,serviceaccounts,roles,rolebindings,cronjobs -n ecommerce
```

```bash
kubectl get ingress -n ecommerce
```

```bash
kubectl get nodes -o wide
```

```bash
kubectl get pods -n ecommerce -o wide
```

```bash
kubectl get deployments -n ecommerce
```

```bash
kubectl get replicasets -n ecommerce
```

---

# Audit Summary

This Kubernetes deployment demonstrates the use of core Kubernetes resources and operational practices required for a production-oriented application.

The e-commerce application has been structured into separate frontend, backend and database workloads and deployed inside the `ecommerce` namespace.

The project demonstrates:

* Containerized application deployment
* Kubernetes Deployments and ReplicaSets
* Service discovery
* Namespace isolation
* Labels and selectors
* Rolling updates and rollback
* Configuration management
* Secret management
* Resource management
* Health checks
* Persistent storage
* Ingress-based routing
* Multi-node Kubernetes architecture
* Horizontal autoscaling
* RBAC and least privilege
* Scheduled workloads
* CI/CD automation

<img width="1919" height="739" alt="Screenshot 2026-10-07 213827" src="https://github.com/user-attachments/assets/ef99cedd-6fc7-4d95-807b-b115a548b4b8" />

---

# Important Note

The status of each item should be marked `✅ Done` **only after the corresponding resource has actually been deployed and verified using the evidence command**.

If a feature has been configured but not successfully tested, change its status to:

```text
⚠️ Configured - Verification Pending
```

This keeps the audit accurate and demonstrates genuine understanding rather than simply listing Kubernetes resources.
