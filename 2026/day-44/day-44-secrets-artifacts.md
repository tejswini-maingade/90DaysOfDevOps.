# Day 44 – Secrets, Artifacts & Running Real Tests in CI

## Task
Today your pipeline starts doing **real work** — storing sensitive values securely, saving build outputs, and running actual tests from your previous days.

---

## Challenge Tasks

### Task 1: GitHub Secrets
1. Go to your repo → Settings → Secrets and Variables → Actions
2. Create a secret called `MY_SECRET_MESSAGE`
3. Create a workflow that reads it and prints: `The secret is set: true` (never print the actual value)
4. Try to print `${{ secrets.MY_SECRET_MESSAGE }}` directly — what does GitHub show?

Write in your notes: Why should you never print secrets in CI logs?

[secret demo yaml file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/secrets-demo.yml)

<img width="1290" height="271" alt="Screenshot 2026-09-18 175149" src="https://github.com/user-attachments/assets/a970959e-6d4e-4836-bcd4-3a58b00a8738" />
<img width="1919" height="694" alt="Screenshot 2026-09-18 175552" src="https://github.com/user-attachments/assets/79452ccd-64f5-4d38-ad72-62833600ec4a" />


GitHub automatically replaces secrets with ***
[secret yaml file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/secrets.yml)

<img width="1917" height="870" alt="Screenshot 2026-09-18 175610" src="https://github.com/user-attachments/assets/56a60ee5-be56-4cd0-9c37-30ed56786048" />


---

### Task 2: Use Secrets as Environment Variables
1. Pass a secret to a step as an environment variable
2. Use it in a shell command without ever hardcoding it
3. Add `DOCKER_USERNAME` and `DOCKER_TOKEN` as secrets (you'll need these on Day 45)
[secret env yaml file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/secret-env.yml)

<img width="1919" height="877" alt="Screenshot 2026-09-18 181058" src="https://github.com/user-attachments/assets/4a320dbb-521f-4d73-b236-d0af80e03d7b" />
<img width="1906" height="729" alt="Screenshot 2026-09-18 180330" src="https://github.com/user-attachments/assets/88345026-0710-4d4b-8419-5b4b871c86c4" />


---

### Task 3: Upload Artifacts
1. Create a step that generates a file — e.g., a test report or a log file
2. Use `actions/upload-artifact` to save it
3. After the workflow runs, download the artifact from the Actions tab

**Verify:** Can you see and download it from GitHub?

- Yes, downloaded it.
[artifact file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/upload-artifact.yml)

<img width="1919" height="865" alt="Screenshot 2026-09-18 181318" src="https://github.com/user-attachments/assets/e9b6857a-567c-405f-8176-7e272dd1d1b3" />

---

### Task 4: Download Artifacts Between Jobs
1. Job 1: generate a file and upload it as an artifact
2. Job 2: download the artifact from Job 1 and use it (print its contents)

Write in your notes: When would you use artifacts in a real pipeline?
Artifacts are used to store and transfer files generated during pipelines.
Test reports,
[artifact between job yaml file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/upload-artifact.yml)

<img width="1919" height="870" alt="Screenshot 2026-09-18 181634" src="https://github.com/user-attachments/assets/8d14b4ce-1119-4367-8d81-e260a913bd9d" />

---

### Task 5: Run Real Tests in CI
Take any script from your earlier days (Python or Shell) and run it in CI:
1. Add your script to the `github-actions-practice` repo
2. Write a workflow that:
   - Checks out the code
   - Installs any dependencies needed
   - Runs the script
   - Fails the pipeline if the script exits with a non-zero code
3. Intentionally break the script — verify the pipeline goes red
4. Fix it — verify it goes green again

[test-yaml-file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/python-tests.yml)

<img width="1919" height="872" alt="Screenshot 2026-09-18 192411" src="https://github.com/user-attachments/assets/8f92b0e6-85be-430d-aa36-bc0cbd768d3d" />
<img width="1919" height="870" alt="Screenshot 2026-09-18 194616" src="https://github.com/user-attachments/assets/84fc15f9-997c-4d64-9320-7d2134f87dea" />

---

### Task 6: Caching
1. Add `actions/cache` to a workflow that installs dependencies
2. Run it twice — observe the time difference
3. Write in your notes: What is being cached and where is it stored?

- What is cache: Python packages downloaded by pip from requirements.txt.
- Where it’s stored: On GitHub Actions servers, restored to the runner at ~/.cache/pip.

[cache-yaml-file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/cache-demo.yml)

<img width="1919" height="867" alt="Screenshot 2026-09-18 194004" src="https://github.com/user-attachments/assets/6210a609-abd7-4c1f-a00f-4cdbc7d3fc76" />

---

**What I lerned from Secret Management**

- **Store sensitive data (like API keys, tokens, passwords) in GitHub Actions Secrets, not in code.**
- **They are encrypted, injected at runtime, and never exposed in logs.**

**The Secret Management Lifecycle**
- Encryption at Rest: When you save a token (like DOCKER_TOKEN) in GitHub's settings, GitHub immediately encrypts it using strong asymmetric encryption before it ever hits their databases.

- Injected on Demand: The secret is only decrypted and injected into the runner environment at the exact moment a specific job or step requests it via the ${{ secrets.YOUR_SECRET }} syntax.

- Automatic Log Masking: If a script accidentally tries to print out or echo that secret to the standard output, GitHub Actions automatically intercepts it and replaces the value with in the build logs.

---

Happy Learning!
**TrainWithShubham**
