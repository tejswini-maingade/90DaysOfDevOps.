# Day 59 – Helm: Kubernetes Package Manager

## Overview

On Day 59 of #90DaysOfDevOps, I learned about **Helm**, a package manager for Kubernetes. Helm simplifies application deployment and management by packaging Kubernetes resources into reusable charts.

Instead of maintaining multiple Kubernetes YAML files manually, Helm allows us to install, configure, upgrade, roll back, and uninstall applications using simple commands.

## Objectives

- Understand Helm and its core components.
- Install and configure Helm.
- Learn about Helm repositories and charts.
- Deploy an NGINX application using a Helm chart.
- Customize deployments using a values file.
- Upgrade and roll back Helm releases.
- Create and test a custom Helm chart.
- Practice troubleshooting Helm and Kubernetes environment issues.

## 1. What Is Helm?

Helm is a package manager for Kubernetes. It helps deploy and manage applications using reusable packages called **charts**.

### Why use Helm?

- Simplifies Kubernetes application deployment.
- Reduces repetitive YAML configuration.
- Supports reusable and customizable templates.
- Makes upgrades and rollbacks easier.
- Helps manage application releases consistently.
- Supports configuration through values files.

## 2. Important Helm Concepts

| Concept | Description |
|---|---|
| Chart | A package containing Kubernetes templates and configuration. |
| Release | An installed instance of a Helm chart. |
| Repository | A location that stores and distributes Helm charts. |
| Values | Configuration settings used to customize a chart. |
| Templates | Files that generate Kubernetes resource manifests. |
| Revision | A version of a Helm release recorded during installation or upgrades. |

## 3. Verify the Kubernetes Cluster

Before installing an application with Helm, verify that the Kubernetes cluster is available.

```bash
kubectl get nodes
kubectl cluster-info
```

The node should show `Ready` before proceeding.

My practice environment uses a Kind cluster named `devops-cluster`.

To check the cluster's status:

```bash
kind get clusters
kubectl get pods -A
```

If the cluster is not running, troubleshoot the cluster before continuing with Helm deployment.

## 4. Verify Helm Installation

Check whether Helm is installed:

```bash
helm version
helm help
```

To view the available commands:

```bash
helm list --help
helm install --help
helm upgrade --help
```

Helm was installed successfully in my EC2 environment. The installed version reported was Helm v3.22.0.

## 5. Understand Helm Repositories

Helm repositories provide access to charts maintained and published by chart providers.

To list configured repositories:

```bash
helm repo list
```

If no repositories are configured, Helm reports that no repositories are found.

Add the Bitnami chart repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Update repository metadata:

```bash
helm repo update
```

Search for NGINX charts:

```bash
helm search repo nginx
```

Inspect the chart's default configuration:

```bash
helm show values bitnami/nginx
```

**Important:** Repository access depends on network connectivity and the chart provider's current repository availability. If the repository cannot be added, resolve the connection issue before treating chart installation as successful.

## 6. Deploy NGINX Using Helm

After the repository is available, install an NGINX release:

```bash
helm install my-nginx bitnami/nginx
```

Here:

- `helm install` installs a chart.
- `my-nginx` is the release name.
- `bitnami/nginx` identifies the chart.

Check the release:

```bash
helm list
helm status my-nginx
```

Check Kubernetes resources:

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

Inspect the generated Kubernetes manifests:

```bash
helm get manifest my-nginx
```

The release should be considered successfully deployed only after Helm and Kubernetes confirm the resources are healthy.

## 7. Customize a Helm Deployment

Helm allows us to customize a chart using command-line options or a YAML values file.

For example, request three replicas and a NodePort service:

```bash
helm install nginx-scaled bitnami/nginx \
  --set replicaCount=3 \
  --set service.type=NodePort
```

Check the deployment:

```bash
helm status nginx-scaled
kubectl get deployments
kubectl get pods
kubectl get services
```

The `--set` option overrides the chart's default configuration.

**Note:** Chart configuration keys can change between chart versions. Verify the supported values using `helm show values` before applying custom settings.

## 8. Create a Custom Values File

Create the Day 59 directory and a configuration file:

```bash
mkdir -p 2026/day-59
nano 2026/day-59/custom-values.yaml
```

Add the following configuration:

```yaml
replicaCount: 2

service:
  type: NodePort
  ports:
    http: 80
    https: 443

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```

### Explanation

- `replicaCount`: Requests two application replicas.
- `service.type`: Configures the service as NodePort.
- `service.ports`: Specifies the intended HTTP and HTTPS ports, if supported by the selected chart.
- `resources.requests`: Defines the minimum CPU and memory resources requested by each container.
- `resources.limits`: Defines the maximum CPU and memory resources allowed for each container.

**Important:** This is a chart-specific configuration example. The `service.ports` structure may not match the current Bitnami NGINX chart schema. Always compare the file with `helm show values bitnami/nginx` and adjust it before installation.

Install a release using the values file:

```bash
helm install nginx-values bitnami/nginx \
  -f 2026/day-59/custom-values.yaml
```

Inspect the resulting configuration:

```bash
helm get values nginx-values
helm status nginx-values
kubectl get deployments
kubectl get services
```

## 9. Upgrade a Helm Release

Helm supports modifying a release without manually editing each generated Kubernetes resource.

Increase the replica count:

```bash
helm upgrade my-nginx bitnami/nginx \
  --set replicaCount=5
```

Check the updated release:

```bash
helm status my-nginx
helm history my-nginx
kubectl get deployments
kubectl get pods
```

The upgrade should create a new release revision if it completes successfully.

## 10. Roll Back a Helm Release

Helm maintains release history that can be used to restore an earlier revision.

View the release history:

```bash
helm history my-nginx
```

Roll back to revision 1:

```bash
helm rollback my-nginx 1
```

Verify the rollback:

```bash
helm history my-nginx
helm status my-nginx
kubectl get deployments
```

A rollback is successful only when Helm reports success and the resulting Kubernetes resources reach their expected state.

## 11. Create a Custom Helm Chart

Helm can generate a starter chart structure.

Create a chart:

```bash
helm create my-app
```

The generated directory contains files such as:

```text
my-app/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── hpa.yaml
│   ├── serviceaccount.yaml
│   ├── NOTES.txt
│   └── _helpers.tpl
└── .helmignore
```

### Understand the important files

- `Chart.yaml`: Chart name, version, and description.
- `values.yaml`: Default configuration values.
- `templates/deployment.yaml`: Template for the Deployment resource.
- `templates/service.yaml`: Template for the Service resource.
- `templates/_helpers.tpl`: Reusable template helpers.
- `templates/NOTES.txt`: Instructions displayed after installation.

### Customize the chart

Open the values file:

```bash
nano my-app/values.yaml
```

Update the relevant settings to use an NGINX image, three replicas, and a ClusterIP service. For example, the core settings should resemble:

```yaml
replicaCount: 3

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.25"

service:
  type: ClusterIP
  port: 80
```

Keep the other fields generated by `helm create` unless you have a reason to change them.

### Validate the chart

Check the chart for common errors:

```bash
helm lint my-app
```

Render the Kubernetes YAML without installing it:

```bash
helm template my-release ./my-app
```

If validation succeeds, install the chart:

```bash
helm install my-release ./my-app
```

Check the installed resources:

```bash
helm status my-release
kubectl get deployments
kubectl get pods
kubectl get services
```

### Upgrade the custom chart

Increase the replicas:

```bash
helm upgrade my-release ./my-app \
  --set replicaCount=5
```

Verify the deployment:

```bash
helm history my-release
kubectl get deployments
kubectl get pods
```

## 12. Troubleshooting

### Issue 1: Bitnami repository installation times out

Command:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Observed error:

```text
Error: context deadline exceeded
```

Investigation showed that `curl` could download the repository index, but Helm's repository command continued to time out. The repository URL redirected to a Broadcom-hosted location.

Troubleshooting commands:

```bash
curl -IL https://charts.bitnami.com/bitnami/index.yaml
curl -fL https://charts.bitnami.com/bitnami/index.yaml \
  -o /tmp/bitnami-index.yaml

helm repo list
helm repo add bitnami https://charts.bitnami.com/bitnami \
  --timeout 5m --debug
```

The direct repository URL was also tested, but the Helm command still timed out.

This remained an environment issue. A successful `curl` download does not prove that `helm repo add` has succeeded.

### Issue 2: EC2 disk space exhausted

The EC2 root filesystem reached 100% usage:

```text
/dev/nvme0n1p1  8.0G  8.0G  16K  100% /
```

Creating a directory failed with:

```text
mkdir: cannot create directory 'helm': No space left on device
```

The inode check showed that inode capacity was available, so the problem was disk space rather than inode exhaustion.

Inspection identified substantial disk usage under `/var/lib/docker` and `/var/cache/dnf`.

To inspect filesystem capacity:

```bash
df -h
df -i
```

To inspect Docker usage:

```bash
docker system df
docker ps -a --size
docker image ls
docker volume ls
```

To inspect package cache usage:

```bash
sudo du -sh /var/cache/dnf
```

The DNF cache was cleaned manually after the normal cleanup command failed due to the full filesystem.

After cleanup, the root filesystem had approximately 330 MB available:

```text
/dev/nvme0n1p1  8.0G  7.7G  330M  96% /
```

The Kind control-plane container was still running, and the active Docker image and volume were retained.

**Lesson learned:** Small EC2 root volumes can quickly fill up during Kubernetes labs. Inspect disk usage regularly and consider increasing the EBS root volume for continued container and Kubernetes practice.

Do not delete active Docker volumes, the Kind container, or `/var/lib/docker` manually.

## 13. Cleanup After Testing

After verifying that you no longer need the test releases, uninstall only the releases you created:

```bash
helm uninstall my-nginx
helm uninstall nginx-scaled
helm uninstall nginx-values
helm uninstall my-release
```

Run only the commands for releases that actually exist.

Check remaining releases:

```bash
helm list -A
```

Verify the cluster is still healthy:

```bash
kubectl get nodes
kubectl get pods -A
```

Do not delete unrelated workloads or the Kind cluster as part of this assignment's cleanup.

## 14. Key Learnings

- Helm simplifies Kubernetes application management.
- Charts package reusable Kubernetes templates.
- Releases represent installed instances of charts.
- Values files make application configuration easier to maintain.
- `helm upgrade` updates an existing release.
- `helm rollback` restores a previous release revision.
- `helm lint` and `helm template` help validate charts before installation.
- Disk capacity and repository connectivity can affect deployment workflows.
- Troubleshooting should begin with inspecting the environment rather than deleting active resources.

## Conclusion

Day 59 introduced Helm as a practical tool for packaging, deploying, and managing applications on Kubernetes. I explored Helm installation, repository configuration, release management, custom values, upgrades, rollbacks, and custom chart creation.

I also investigated repository timeouts and an exhausted EC2 root filesystem, learning the importance of environment checks and safe resource management.

**Status:** Helm installation was verified. Bitnami repository access and subsequent chart deployment still require successful verification in the EC2 environment before they can be marked complete.
