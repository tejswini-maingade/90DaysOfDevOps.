# Day 54 – Kubernetes ConfigMaps and Secrets

## Task
Your application needs configuration — database URLs, feature flags, API keys. Hardcoding these into container images means rebuilding every time a value changes. Kubernetes solves this with ConfigMaps for non-sensitive config and Secrets for sensitive data.

---

## Challenge Tasks

### Task 1: Create a ConfigMap from Literals
1. Use `kubectl create configmap` with `--from-literal` to create a ConfigMap called `app-config` with keys `APP_ENV=production`, `APP_DEBUG=false`, and `APP_PORT=8080`
2. Inspect it with `kubectl describe configmap app-config` and `kubectl get configmap app-config -o yaml`
3. Notice the data is stored as plain text — no encoding, no encryption

**Verify:** Can you see all three key-value pairs?

- Yes, all 3 key-value pairs are visible in plain text
- No encoding, no encryption

<img width="1919" height="725" alt="Screenshot 2026-10-08 105110" src="https://github.com/user-attachments/assets/78c822c7-ae27-4e18-91a9-35653237c089" />


---

### Task 2: Create a ConfigMap from a File
1. Write a custom Nginx config file that adds a `/health` endpoint returning "healthy"
2. Create a ConfigMap from this file using `kubectl create configmap nginx-config --from-file=default.conf=<your-file>`
3. The key name (`default.conf`) becomes the filename when mounted into a Pod

**Verify:** Does `kubectl get configmap nginx-config -o yaml` show the file contents?

- Yes file contents are fully visible in YAML

<img width="1000" height="319" alt="Screenshot 2026-10-08 105143" src="https://github.com/user-attachments/assets/51bb0037-50be-4f90-83ec-8dccf2de0c63" />


---

### Task 3: Use ConfigMaps in a Pod
1. Write a Pod manifest that uses `envFrom` with `configMapRef` to inject all keys from `app-config` as environment variables. Use a busybox container that prints the values.
2. Write a second Pod manifest that mounts `nginx-config` as a volume at `/etc/nginx/conf.d`. Use the nginx image.
3. Test that the mounted config works: `kubectl exec <pod> -- curl -s http://localhost/health`

Use environment variables for simple key-value settings. Use volume mounts for full config files.

**Verify:** Does the `/health` endpoint respond?

```kubectl exec nginx-config -- curl -s http://localhost/health```

<img width="1573" height="679" alt="Screenshot 2026-10-08 105429" src="https://github.com/user-attachments/assets/0e92f9be-0778-4a86-888a-f7bc62fca307" />
<img width="1150" height="386" alt="Screenshot 2026-10-08 105818" src="https://github.com/user-attachments/assets/2b083301-b803-444e-ad24-6c4b52791998" />
<img width="1420" height="289" alt="Screenshot 2026-10-08 110713" src="https://github.com/user-attachments/assets/e6cd32c5-fc02-44a9-8e49-2863f323ed4b" />


---

### Task 4: Create a Secret
1. Use `kubectl create secret generic db-credentials` with `--from-literal` to store `DB_USER=admin` and `DB_PASSWORD=s3cureP@ssw0rd`
2. Inspect with `kubectl get secret db-credentials -o yaml` — the values are base64-encoded
3. Decode a value: `echo '<base64-value>' | base64 --decode`

**base64 is encoding, not encryption.** Anyone with cluster access can decode Secrets. The real advantages are RBAC separation, tmpfs storage on nodes, and optional encryption at rest.

**Verify:** Can you decode the password back to plaintext?

- Yes, decode the password back to plaintext
  
<img width="1919" height="578" alt="Screenshot 2026-10-08 111104" src="https://github.com/user-attachments/assets/ba1ca624-0d73-45e1-af4e-6d6be2538236" />


---

### Task 5: Use Secrets in a Pod
1. Write a Pod manifest that injects `DB_USER` as an environment variable using `secretKeyRef`
2. In the same Pod, mount the entire `db-credentials` Secret as a volume at `/etc/db-credentials` with `readOnly: true`
3. Verify: each Secret key becomes a file, and the content is the decoded plaintext value

**Verify:** Are the mounted file values plaintext or base64?

- Mounted file values planintext
  
<img width="1494" height="524" alt="Screenshot 2026-10-08 111509" src="https://github.com/user-attachments/assets/d5e5cc97-002f-4981-ab38-1caa3f170b09" />

---

### Task 6: Update a ConfigMap and Observe Propagation
1. Create a ConfigMap `live-config` with a key `message=hello`
2. Write a Pod that mounts this ConfigMap as a volume and reads the file in a loop every 5 seconds
3. Update the ConfigMap: `kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'`
4. Wait 30-60 seconds — the volume-mounted value updates automatically
5. Environment variables from earlier tasks do NOT update — they are set at pod startup only

**Verify:** Did the volume-mounted value change without a pod restart?

- Yes, the volume-mounted value does change without restarting the Pod.

<img width="1919" height="731" alt="Screenshot 2026-10-08 111838" src="https://github.com/user-attachments/assets/b67e71a5-c529-4306-82a7-9756b56a42c1" />


---

### Task 7: Clean Up
Delete all pods, ConfigMaps, and Secrets you created.

<img width="1090" height="683" alt="Screenshot 2026-10-08 112456" src="https://github.com/user-attachments/assets/e5443995-9a51-4120-afa0-d18ac6487648" />


---

## Documentation

**What ConfigMaps and Secrets are and when to use each**

- `ConfigMap` stores non-sensitive data (e.g., config, URLs)
- `Secret` stores sensitive data (e.g., passwords, tokens)
-  Secrets use base64 (not secure by itself)

**The difference between environment variables and volume mounts**

`Environment Variables:`
- Injected at Pod startup
- Do NOT update if ConfigMap/Secret changes

`Volume Mounts:`
- Data is available as files inside container
- Auto-updates (after ~30–60 seconds)

**Why base64 is encoding, not encryption**

- Base64 is just encoding, not secure
- It can be easily decoded by anyone (no key needed)
- In `Kubernetes Secrets:`
  - Data is base64 only for safe storage in YAML
  - Anyone with access can decode it

**How ConfigMap updates propagate to volumes but not env vars**

- `ConfigMap as volume` updates automatically without restart
- `ConfigMap as env var` stays same until Pod restart

---

## Learn in Public
Share on LinkedIn: "Learned Kubernetes ConfigMaps and Secrets today. Injected config as environment variables and volume mounts, and discovered that base64 encoding is not encryption."

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
