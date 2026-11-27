# Day 80 – Helm Project: Multi-Environment Deployment and CI/CD

## Overview

Today, I completed Day 80 of the #90DaysOfDevOps challenge by working on a multi-environment Helm deployment for the AI-BankApp project.

In the previous two days, I learned Helm fundamentals and created a custom Helm chart. Today, I extended that knowledge by configuring environment-specific deployments, implementing Helm hooks, packaging the chart, and understanding how Helm integrates with a GitOps-based CI/CD pipeline.

**Project Reference:** [AI-BankApp-DevOps](https://github.com/TrainWithShubham/AI-BankApp-DevOps)

**Branch:** `feat/gitops`

### Objectives

- Create environment-specific Helm values for Dev, Staging, and Production.
- Implement Helm hooks for database readiness validation.
- Configure Helm tests to verify application connectivity.
- Package and version the Helm chart.
- Understand Helm integration with GitHub Actions and ArgoCD.
- Explore production Helm deployment best practices.
- Compare Helm, Raw Kubernetes Manifests, and Kustomize.

---

## 1. Environment-Specific Helm Values

One of the biggest advantages of Helm is that we can use a single chart to deploy an application across multiple environments.

Instead of maintaining separate Kubernetes manifests for every environment, Helm allows us to maintain one reusable chart and override configurations through different values files.

For the AI-BankApp, I created three configuration files:

```text
bankapp/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
├── values-prod.yaml
└── templates/
```

### 1.1 Development Environment

File: `bankapp/values-dev.yaml`

```yaml
bankapp:
  replicaCount: 1
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "latest"
    pullPolicy: Always
  resources:
    requests:
      memory: "256Mi"
      cpu: "100m"
    limits:
      memory: "512Mi"
      cpu: "250m"
  autoscaling:
    enabled: false

mysql:
  enabled: true
  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "256Mi"
      cpu: "250m"
  persistence:
    size: 2Gi
    storageClass: standard

ollama:
  enabled: true
  model: tinyllama
  resources:
    requests:
      memory: "1Gi"
      cpu: "500m"
    limits:
      memory: "1.5Gi"
      cpu: "1000m"
  persistence:
    size: 5Gi
    storageClass: standard

storageClass:
  create: false
```

**Explanation:**

- One application replica is sufficient for development.
- The latest Docker image is used for frequent testing.
- Autoscaling is disabled.
- MySQL uses 2Gi persistent storage.
- Ollama runs the TinyLlama model.
- Smaller resource requests help reduce development infrastructure costs.

### 1.2 Staging Environment

File: `bankapp/values-staging.yaml`

```yaml
bankapp:
  replicaCount: 2
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 3
    targetCPUUtilization: 75

mysql:
  enabled: true
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  persistence:
    size: 5Gi
    storageClass: gp3

ollama:
  enabled: true
  model: tinyllama
  persistence:
    size: 10Gi
    storageClass: gp3

# Supply credentials through Kubernetes Secrets
# Do not commit real passwords to Git.

storageClass:
  create: true
```

**Explanation:**

- Two replicas provide better availability.
- HPA automatically adjusts replicas between 2 and 3.
- A fixed application image version provides consistent testing.
- MySQL storage is increased to 5Gi.
- Ollama receives more persistent storage.
- AWS gp3 storage is used for EKS environments.

### 1.3 Production Environment

File: `bankapp/values-prod.yaml`

```yaml
bankapp:
  replicaCount: 4
  image:
    repository: trainwithshubham/ai-bankapp-eks
    tag: "v1.2.0"
    pullPolicy: IfNotPresent
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 4
    targetCPUUtilization: 70

mysql:
  enabled: true
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
  persistence:
    size: 20Gi
    storageClass: gp3

ollama:
  enabled: true
  model: tinyllama
  resources:
    requests:
      memory: "2Gi"
      cpu: "900m"
    limits:
      memory: "2.5Gi"
      cpu: "1500m"
  persistence:
    size: 10Gi
    storageClass: gp3

storageClass:
  create: true

gateway:
  enabled: true
```

**Explanation:**

- Production uses a stable application image version.
- Four initial replicas are configured, with HPA managing a range of 2–4 replicas.
- MySQL receives 20Gi persistent storage.
- Ollama receives higher resource allocations.
- Gateway is enabled for production traffic management.
- Production configuration is designed for higher availability and scalability.

**Important:** The values files must match the actual keys and templates in the custom chart. Also, production passwords should never be stored in Git. Use an external secrets solution.

### 1.4 Environment Comparison

| Configuration | Dev | Staging | Production |
|---|---|---|---|
| Replicas | 1 | 2–3 | 2–4 |
| Image tag | latest | v1.2.0 | v1.2.0 |
| Autoscaling | Disabled | Enabled | Enabled |
| MySQL storage | 2Gi | 5Gi | 20Gi |
| Ollama memory request | 1Gi | Chart default | 2Gi |
| Gateway | Disabled | Disabled | Enabled |

### 1.5 Deploying Different Environments

**Development deployment on Kind:**

```bash
helm install bankapp-dev bankapp/ \
  -f bankapp/values-dev.yaml \
  -n dev --create-namespace
```

**Validate staging configuration:**

```bash
helm template bankapp-staging bankapp/ \
  -f bankapp/values-staging.yaml | grep "replicas:"
```

**Validate production configuration:**

```bash
helm template bankapp-prod bankapp/ \
  -f bankapp/values-prod.yaml | grep "replicas:"
```

The `helm template` command renders Kubernetes manifests locally without deploying them to a cluster.

---

## 2. Implementing Helm Hooks

Helm hooks allow us to execute specific Kubernetes resources at particular stages of a Helm release lifecycle.

For the AI-BankApp, database readiness is important because the Spring Boot application depends on MySQL.

### 2.1 Create a Pre-Install Hook

Create the following file:

`bankapp/templates/pre-install-job.yaml`

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "bankapp.fullname" . }}-db-ready
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation

spec:
  template:
    spec:
      containers:
        - name: db-check
          image: busybox:1.36
          command:
            - /bin/sh
            - -c
            - |
              echo "Waiting for MySQL to be ready..."

              until nc -z {{ include "bankapp.fullname" . }}-mysql 3306; do
                echo "MySQL not ready, retrying in 3 seconds..."
                sleep 3
              done

              echo "MySQL is ready!"

          resources:
            requests:
              memory: "32Mi"
              cpu: "50m"
            limits:
              memory: "64Mi"
              cpu: "100m"

      restartPolicy: Never

  backoffLimit: 10
```

### 2.2 Understanding Hook Annotations

| Annotation | Purpose |
|---|---|
| `helm.sh/hook` | Defines when the hook executes |
| `pre-install` | Executes before installation |
| `pre-upgrade` | Executes before an upgrade |
| `helm.sh/hook-weight` | Controls execution order |
| `helm.sh/hook-delete-policy` | Defines when old hook resources are deleted |

**How it works:**

1. Helm starts the installation or upgrade process.
2. The hook Job checks MySQL connectivity.
3. It retries until MySQL accepts connections.
4. After successful validation, Helm continues the release operation.

**Important implementation consideration:**

A pre-install hook runs before normal resources belonging to the same Helm release are created. Therefore, if MySQL is also created by this chart, this pre-install Job cannot wait for that newly created MySQL service.

For a MySQL instance deployed in the same release, use an application init container or an appropriate post-install readiness workflow. The pre-install hook is suitable when the database already exists independently.

---

## 3. Helm Test

Helm also supports test hooks that help validate whether an application is functioning after deployment.

Create:

`bankapp/templates/tests/test-connection.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: {{ include "bankapp.fullname" . }}-test
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test

spec:
  containers:
    - name: test
      image: busybox:1.36
      command:
        - sh
        - -c
        - wget -qO- http://{{ include "bankapp.fullname" . }}-service:8080/actuator/health

  restartPolicy: Never
```

Run the test:

```bash
helm test bankapp-dev -n dev
```

Check the test Pod:

```bash
kubectl get pods -n dev
```

Check its logs:

```bash
kubectl logs -n dev <test-pod-name>
```

**Expected result:** The test should complete successfully and return the Spring Boot health endpoint response.

Note: Confirm that the generated Service name and port match the actual Helm chart. A successful test requires the application endpoint to be reachable.

---

## 4. Packaging and Versioning the Helm Chart

Helm supports packaging charts into `.tgz` archives, which can be distributed and installed in different Kubernetes environments.

### 4.1 Lint the Chart

```bash
helm lint bankapp/
```

This checks the chart structure, metadata, and common configuration problems.

### 4.2 Package the Chart

```bash
helm package bankapp/
```

Expected output:

```text
Successfully packaged chart and saved it to:
bankapp-0.1.0.tgz
```

### 4.3 Update Chart Version

Edit `bankapp/Chart.yaml`:

```yaml
apiVersion: v2
name: bankapp
description: Helm chart for AI-BankApp
type: application

version: 0.2.0
appVersion: "1.1.0"
```

**Version explanation:**

- `version`: Version of the Helm chart itself.
- `appVersion`: Version of the application deployed by the chart.

Package again:

```bash
helm package bankapp/
```

Now the chart archive is:

```text
bankapp-0.2.0.tgz
```

Keep both archives if you want to retain both versions.

### 4.4 Install from a Packaged Chart

```bash
helm install my-bankapp bankapp-0.2.0.tgz \
  -f bankapp/values-dev.yaml \
  -n bankapp --create-namespace
```

### 4.5 Create a Helm Chart Repository

```bash
mkdir chart-repo

cp bankapp-*.tgz chart-repo/

helm repo index chart-repo/ \
  --url https://your-username.github.io/helm-charts
```

View the generated repository index:

```bash
cat chart-repo/index.yaml
```

This index file contains metadata about the packaged charts and their versions.

---

## 5. Helm Integration with the GitOps CI/CD Pipeline

The AI-BankApp project uses GitHub Actions and ArgoCD to automate application delivery.

### 5.1 Existing GitOps Pipeline

The existing pipeline follows this flow:

```text
Developer pushes code
        |
        v
GitHub Actions starts
        |
        v
Build Docker image
        |
        v
Tag image with Git commit SHA
        |
        v
Update Kubernetes deployment YAML
        |
        v
Commit changes to GitHub
        |
        v
ArgoCD detects repository changes
        |
        v
ArgoCD syncs changes to EKS
        |
        v
Application deployed
```

### 5.2 GitOps Pipeline Using Helm

Instead of modifying raw Kubernetes manifests, we can update the image tag inside the Helm values file.

```text
Developer pushes code
        |
        v
GitHub Actions starts
        |
        v
Build Docker image
        |
        v
Generate Git commit SHA tag
        |
        v
Update Helm values.yaml
        |
        v
Commit changes to GitHub
        |
        v
ArgoCD detects Git changes
        |
        v
ArgoCD renders Helm templates
        |
        v
ArgoCD applies manifests to EKS
        |
        v
Application deployed
```

### 5.3 GitHub Actions Helm Integration

Example workflow steps:

```yaml
- name: Update Helm values with new image tag
  run: |
    TAG=${{ steps.tag.outputs.sha_short }}

    yq -i '.bankapp.image.tag = strenv(TAG)' \
      helm-chart/bankapp/values-prod.yaml

  env:
    TAG: ${{ steps.tag.outputs.sha_short }}

- name: Commit updated Helm values
  run: |
    git config user.name "github-actions[bot]"
    git config user.email \
      "github-actions[bot]@users.noreply.github.com"

    git add helm-chart/bankapp/values-prod.yaml

    git diff --staged --quiet || \
      git commit -m "ci: update bankapp image [skip ci]"

    git push
```

The `yq` command updates the image tag without changing the overall YAML structure.

### 5.4 ArgoCD Integration with Helm

For an ArgoCD Application, the source configuration can point directly to the Helm chart.

```yaml
spec:
  source:
    repoURL: https://github.com/your-username/AI-BankApp-DevOps.git
    targetRevision: feat/gitops
    path: helm-chart/bankapp

    helm:
      valueFiles:
        - values-prod.yaml
```

ArgoCD automatically renders Helm templates and manages the resulting Kubernetes resources.

**Important:** ArgoCD uses Helm for rendering and applies the rendered manifests through its own reconciliation process. It does not normally perform a traditional `helm upgrade` release operation.

### 5.5 Advantages of ArgoCD + Helm

1. **Environment management:** One chart can support multiple environments.
2. **Less duplication:** No need to maintain separate Kubernetes YAML files.
3. **Version control:** All deployment configuration changes are stored in Git.
4. **Automated synchronization:** ArgoCD detects changes and reconciles the cluster.
5. **Rollback and history:** Git history provides a clear record of configuration changes.
6. **Consistency:** The same templates can be used across Dev, Staging, and Production.

---

## 6. Production Helm Best Practices

### 6.1 Use Helm Upgrade --Install

```bash
helm upgrade --install bankapp bankapp/ \
  -f bankapp/values-prod.yaml \
  --set bankapp.image.tag=$GIT_SHA \
  -n bankapp \
  --create-namespace \
  --wait \
  --timeout 300s \
  --atomic
```

**Important flags:**

| Flag | Purpose |
|---|---|
| `upgrade --install` | Installs if missing, otherwise upgrades |
| `-f` | Loads environment-specific values |
| `--set` | Overrides a particular value |
| `--wait` | Waits for supported resources to become ready |
| `--timeout` | Sets the maximum wait duration |
| `--atomic` | Rolls back a failed upgrade and uninstalls a failed initial installation |

### 6.2 Use Helm Diff

Install the Helm Diff plugin:

```bash
helm plugin install \
  https://github.com/databus23/helm-diff
```

Preview changes before upgrading:

```bash
helm diff upgrade bankapp bankapp/ \
  -f bankapp/values-prod.yaml
```

This helps identify changes before applying them to production.

### 6.3 Resource Quotas

Resource quotas help control the amount of CPU and memory consumed within a Kubernetes namespace.

Create:

`bankapp/templates/resourcequota.yaml`

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: {{ include "bankapp.fullname" . }}-quota
  namespace: {{ .Release.Namespace }}

spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
```

### 6.4 Production Secrets Management

Passwords and other sensitive information should never be committed directly into Git repositories.

Recommended solutions:

- AWS Secrets Manager
- External Secrets Operator
- Sealed Secrets
- HashiCorp Vault

For an AWS EKS deployment, External Secrets Operator can retrieve credentials from AWS Secrets Manager and create Kubernetes Secrets.

This improves security by separating application configuration from sensitive credentials.

---

## 7. Helm vs Raw Manifests vs Kustomize

All three approaches are useful for Kubernetes deployments, but they solve different problems.

| Feature | Raw Manifests | Helm | Kustomize |
|---|---|---|---|
| Configuration | Static YAML | Values and templates | Base and overlays |
| Reusability | Limited | High | High |
| Multi-environment | Requires duplication | Separate values files | Separate overlays |
| Templating | No | Yes | No |
| Complexity | Low | Medium | Medium |
| Package management | No | Yes | No |

### When to Use Each Approach

**Raw Kubernetes Manifests**

Best for simple applications with limited configuration and a single deployment environment.

AI-BankApp example: The original `k8s/` directory.

**Helm**

Best for reusable applications, complex deployments, environment-specific configurations, and packaged Kubernetes applications.

AI-BankApp example: The custom chart containing application, MySQL, Ollama, HPA, and hooks.

**Kustomize**

Best for modifying existing Kubernetes manifests using overlays without introducing template logic.

AI-BankApp example: Maintaining separate Dev, Staging, and Production overlays for the existing `k8s/` directory.

---

## 8. Three-Day Helm Learning Journey

| Day | Topic | AI-BankApp Connection |
|---|---|---|
| Day 78 | Helm installation, repositories, values, upgrades, and rollback | Deployed MySQL using a Helm chart |
| Day 79 | Custom Helm chart and Go templates | Converted Kubernetes manifests into a reusable chart |
| Day 80 | Multi-environment values, hooks, packaging, and CI/CD | Prepared environment-specific deployment configurations and GitOps integration |

### Key Learnings

- Helm simplifies Kubernetes application deployment.
- Values files allow environment-specific configuration.
- Helm hooks automate lifecycle operations.
- Helm tests validate application connectivity.
- Chart packaging makes applications easier to distribute.
- ArgoCD supports Helm charts natively.
- Production deployments require proper resource management and secrets handling.

---

## 9. Verification and Cleanup

Before cleaning up, inspect Helm releases:

```bash
helm list -A
```

Check Kubernetes resources:

```bash
kubectl get pods -A
kubectl get services -A
kubectl get deployments -A
```

Check Helm release details:

```bash
helm status bankapp-dev -n dev
```

Run the Helm test:

```bash
helm test bankapp-dev -n dev
```

### Cleanup

Uninstall the development release:

```bash
helm uninstall bankapp-dev -n dev
```

Delete the development namespace:

```bash
kubectl delete namespace dev
```

Delete the Kind cluster if it was created specifically for this exercise:

```bash
kind delete cluster --name tws-cluster
```

**Note:** Run cleanup commands only after confirming that you no longer need the deployed resources. Persistent volumes and data may require separate cleanup.

---

## 10. Final Outcome

Through this three-day Helm learning journey, I gained practical knowledge of Helm chart management and its role in Kubernetes deployments.

I learned how to manage different environments using one chart, validate database connectivity, package Helm charts, and integrate deployment configuration changes into a GitOps workflow.

The most important takeaway is that Helm reduces configuration duplication and makes Kubernetes deployments more reusable, consistent, and manageable.

**One Chart. Three Environments. Automated Deployments.**

---



*The structure above is the suggested documentation and project layout. Include actual screenshots and command outputs after running the deployment and verification steps.*

---
