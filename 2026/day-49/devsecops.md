# Day 49 – DevSecOps: Add Security to Your CI/CD Pipeline

## Overview

On Day 49, I added security checks to my CI/CD pipeline by integrating **DevSecOps practices** into the GitHub Actions workflow.

The goal was to identify security vulnerabilities before Docker images are pushed or deployed.

The pipeline now includes:

* Docker image vulnerability scanning with **Trivy**
* Dependency review for Pull Requests
* GitHub Secret Scanning and Push Protection
* Workflow permissions hardening
* Security checks before Docker image push
* Failure of the pipeline when HIGH or CRITICAL vulnerabilities are detected

---

## What is DevSecOps?

**DevSecOps = Development + Security + Operations**

DevSecOps integrates security into the development and CI/CD process instead of performing security checks only after an application is deployed.

### Traditional approach

```text
Developer
   ↓
Build
   ↓
Test
   ↓
Deploy
   ↓
Security Check
```

Security is performed late in the process.

### DevSecOps approach

```text
Developer
   ↓
Code
   ↓
Build
   ↓
Test
   ↓
Security Scan
   ↓
Docker Image Scan
   ↓
Push
   ↓
Deploy
```

Security becomes part of the CI/CD pipeline.

---

# 1. Trivy Vulnerability Scanning

## What is Trivy?

**Trivy** is an open-source security scanner used to detect vulnerabilities in:

* Container images
* Operating system packages
* Application dependencies
* Filesystems
* Git repositories
* Kubernetes configurations
* Infrastructure-as-Code

For this project, Trivy was used to scan the Docker image before pushing it to Docker Hub.

---

# 2. Why Trivy Was Added

The Docker image may contain vulnerable:

* OS packages
* Node.js packages
* npm dependencies
* Other software components

Therefore, the pipeline should not push an image containing serious vulnerabilities.

The security flow is:

```text
Docker Build
     ↓
Trivy Scan
     ↓
HIGH / CRITICAL?
   ↙       ↘
 YES       NO
  ↓         ↓
FAIL      Continue
            ↓
       Docker Push
```

---

# 3. Trivy GitHub Actions Configuration

The reusable Docker workflow was updated to scan the image after building it and before pushing it.

```yaml
- name: Trivy vulnerability scan
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ${{ secrets.docker_username }}/${{ inputs.image_name }}:${{ inputs.tag }}
    format: table
    severity: HIGH,CRITICAL
    ignore-unfixed: false
    exit-code: '1'
```

### Important configuration

| Setting                   | Purpose                                              |
| ------------------------- | ---------------------------------------------------- |
| `image-ref`               | Specifies the Docker image to scan                   |
| `format: table`           | Displays results in table format                     |
| `severity: HIGH,CRITICAL` | Checks HIGH and CRITICAL vulnerabilities             |
| `ignore-unfixed: false`   | Does not ignore vulnerabilities without fixes        |
| `exit-code: '1'`          | Fails the workflow when vulnerabilities are detected |

The pipeline therefore prevents vulnerable images from being pushed.

---

# 4. Trivy Vulnerability Issue

During the implementation, Trivy initially reported several vulnerabilities.

The important finding was:

```text
Node.js (node-pkg)

Total: 4 (HIGH: 4, CRITICAL: 0)
```

The affected packages were:

```text
brace-expansion
ip-address
tar
```

The required fixed versions identified by Trivy were:

```text
brace-expansion → 5.0.9
ip-address      → 10.3.1
tar             → 7.5.21
```

The backend dependency tree was checked with:

```bash
cd /workspaces/ecommerce-app/server

npm ls brace-expansion ip-address tar
```

The result showed:

```text
brace-expansion@5.0.9
ip-address@10.3.1
tar@7.5.21
```

This confirmed that the application dependencies had been updated.

---

# 5. Finding the Actual Trivy Issue

The important part of the Trivy report was that the vulnerable packages were located under npm's global installation:

```text
/usr/local/lib/node_modules/npm/node_modules/
```

The Dockerfile contained:

```dockerfile
RUN npm install --global npm@latest
```

This installed a global npm version together with npm's bundled dependencies.

Therefore, even though the application dependencies had been fixed, Trivy was still finding vulnerable packages inside the globally installed npm package.

---

# 6. Final Backend Dockerfile

The backend Dockerfile was changed to avoid installing another global npm version.

```dockerfile
FROM node:24-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev \
    && npm cache clean --force

COPY . .

# npm is only needed while building the image.
# Remove it from the final runtime image so Trivy
# does not scan npm's bundled dependencies.
RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/bin/npm \
    /usr/local/bin/npx

EXPOSE 5000

CMD ["node", "index.js"]
```

### Why was npm removed?

The application starts with:

```dockerfile
CMD ["node", "index.js"]
```

The production container does not need npm to run the application.

npm is required during the image build to install dependencies, but it is not required by the running Node.js application.

Therefore, removing npm from the final runtime image reduces unnecessary software and removes the vulnerable npm dependency tree identified by Trivy.

---

# 7. Why Alpine Linux Was Used

The original backend image used:

```dockerfile
FROM node:24-bookworm-slim
```

Trivy detected many Debian OS-level vulnerabilities in that image.

The image contained vulnerabilities in packages such as:

* util-linux
* perl-base
* zlib1g
* libmount
* libuuid
* mount

The image was changed to:

```dockerfile
FROM node:24-alpine
```

Alpine provides a smaller runtime image and, in this scan, significantly reduced the OS-level vulnerability findings.

The final image was therefore based on:

```text
Node.js 24
Alpine Linux
```

---

# 8. Dependency Review for Pull Requests

Dependency Review was added to the Pull Request workflow.

The purpose is to detect vulnerable dependencies introduced by a Pull Request.

Example configuration:

```yaml
- name: Dependency Review
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

The workflow can therefore detect dependency changes before they are merged into the main branch.

---

# 9. GitHub Secret Scanning

GitHub Secret Scanning was enabled for the repository.

Secret scanning helps identify accidentally committed sensitive information such as:

* API keys
* Access tokens
* Cloud credentials
* Private keys
* Authentication secrets

Push Protection can also prevent detected secrets from being pushed to the repository.

This helps protect sensitive credentials before they become part of the Git history.

---

# 10. Workflow Permissions

Workflow permissions were restricted using:

```yaml
permissions:
  contents: read
```

This follows the principle of least privilege.

Instead of giving a GitHub Actions workflow unnecessary permissions, only the permissions required by the workflow should be granted.

Example:

```yaml
name: Build and Test

on:
  push:
    branches:
      - main

permissions:
  contents: read
```

---

# 11. Secure CI/CD Pipeline

The final DevSecOps pipeline follows this structure:

```text
                    Developer
                        |
                        v
                   Pull Request
                        |
                        v
              +-------------------+
              | Dependency Review |
              +-------------------+
                        |
                        v
                  Build & Test
                        |
                        v
              Merge to main branch
                        |
                        v
                  Build Docker
                     Image
                        |
                        v
                +---------------+
                |     Trivy     |
                | Vulnerability |
                |     Scan      |
                +---------------+
                   /         \
                 FAIL        PASS
                  |            |
                  v            v
              Stop Pipeline   Docker Push
                                  |
                                  v
                              Deployment
```

---

# 12. Security Gates

The pipeline now contains security gates.

### Pull Request

```text
Pull Request
     ↓
Dependency Review
     ↓
Build & Test
     ↓
Merge
```

### Main Branch

```text
Main
 ↓
Build & Test
 ↓
Docker Build
 ↓
Trivy Scan
 ↓
HIGH/CRITICAL?
 ↓
No
 ↓
Docker Push
 ↓
Deploy
```

If Trivy detects HIGH or CRITICAL vulnerabilities, the workflow stops.

---

# 13. Backend Dependency Verification

The backend dependency versions were verified using:

```bash
cd /workspaces/ecommerce-app/server

npm ls brace-expansion ip-address tar
```

Expected result:

```text
brace-expansion@5.0.9
ip-address@10.3.1
tar@7.5.21
```

This confirms that the vulnerable versions reported earlier were replaced in the application dependency tree.

---

# 14. Git Commands Used

After updating the Dockerfile and dependency configuration:

```bash
git status
```

Review the changes:

```bash
git diff
```

Stage the required file:

```bash
git add server/Dockerfile
```

Commit the change:

```bash
git commit -m "fix Trivy npm vulnerabilities in backend image"
```

Push to GitHub:

```bash
git push origin main
```

GitHub Actions then automatically starts the pipeline.

---

# 15. Verification

After pushing the changes, the GitHub Actions pipeline should execute:

```text
Checkout
   ↓
Build & Test
   ↓
Docker Build
   ↓
Trivy Scan
   ↓
Docker Login
   ↓
Docker Push
```

The Trivy step should complete successfully when no HIGH or CRITICAL vulnerabilities are detected.

The Docker image is pushed only after the security scan passes.

---

# 16. Important Learning

One important lesson from this task was that fixing application dependencies alone is not always enough.

For example:

```text
Application dependencies
        ↓
    npm packages
        ↓
      Fixed
```

But the Docker image can also contain:

```text
Operating system packages
Node.js
npm
npm bundled dependencies
Other system tools
```

Therefore, container security scanning needs to inspect the **complete image**, not only the application's `package.json`.

---

# 17. DevSecOps Best Practices Learned

### 1. Shift security left

Security checks should happen early in the development lifecycle.

### 2. Scan before deployment

Images should be scanned before they are pushed or deployed.

### 3. Use security gates

HIGH and CRITICAL vulnerabilities can be used as pipeline blockers.

### 4. Keep dependencies updated

Dependencies should be regularly checked and updated.

### 5. Minimize runtime images

Remove unnecessary build-time tools from production images.

### 6. Use least-privilege permissions

GitHub Actions should receive only the permissions required by the workflow.

### 7. Protect secrets

Secret scanning and push protection help prevent accidental credential exposure.

---

# 18. Final Result

Day 49 introduced DevSecOps security controls into the CI/CD pipeline.

The final pipeline includes:

* ✅ GitHub Actions
* ✅ Build and Test
* ✅ Dependency Review
* ✅ Docker Image Build
* ✅ Trivy Vulnerability Scan
* ✅ HIGH/CRITICAL security gate
* ✅ Docker Hub Push
* ✅ GitHub Secret Scanning
* ✅ Push Protection
* ✅ Restricted workflow permissions
* ✅ Security before deployment

The key concept learned was:

> **Security should be integrated into CI/CD rather than treated as a separate activity after deployment.**

<img width="1916" height="876" alt="Screenshot 2026-09-21 233344" src="https://github.com/user-attachments/assets/66cab38a-e627-4081-8e1f-15d2647e9a0c" />
<img width="1919" height="866" alt="Screenshot 2026-09-21 232910" src="https://github.com/user-attachments/assets/43f12368-1de5-454c-b6d7-0b61549b3591" />

---

## Day 49 Checklist

* [x] Add Trivy container scanning
* [x] Scan Docker image before push
* [x] Fail pipeline on HIGH/CRITICAL vulnerabilities
* [x] Fix vulnerable backend dependencies
* [x] Remove unnecessary global npm from runtime image
* [x] Use Node.js Alpine image
* [x] Add Dependency Review
* [x] Enable Secret Scanning
* [x] Enable Push Protection
* [x] Add `contents: read` permissions
* [x] Verify secure CI/CD flow
* [ ] Add screenshot of successful Trivy security scan
* [ ] Add screenshot of GitHub Actions pipeline
* [ ] Add screenshot of Secret Scanning settings
* [ ] Add screenshot of Dependency Review
