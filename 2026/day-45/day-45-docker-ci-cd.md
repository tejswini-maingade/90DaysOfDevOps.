# Day 45 – Docker Build & Push in GitHub Actions

## Task
Today you build a **complete CI/CD pipeline** — code pushed to GitHub automatically builds a Docker image and ships it to Docker Hub. No manual steps.

This is exactly what happens in real production pipelines.

---

## Challenge Tasks

### Task 1: Prepare
1. Use the app you Dockerized on Day 36 (or any simple Dockerfile)
2. Add the Dockerfile to your `github-actions-practice` repo (or create a minimal one)
3. Make sure `DOCKER_USERNAME` and `DOCKER_TOKEN` secrets are set from Day 44

<img width="1919" height="741" alt="Screenshot 2026-09-18 213810" src="https://github.com/user-attachments/assets/fefcbf89-cc9a-432c-86a7-8615a4ff1aed" />


---

### Task 2: Build the Docker Image in CI
Create `.github/workflows/docker-publish.yml` that:
1. Triggers on push to `main`
2. Checks out the code
3. Builds the Docker image and tags it

**Verify:** Check the build step logs — does the image build successfully?

- Yes,image build successfully
[docker-yaml-file](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/docker-publish.yml)

<img width="1917" height="874" alt="Screenshot 2026-09-18 212239" src="https://github.com/user-attachments/assets/017946c1-840e-4e41-a96d-5a36f6ea60e7" />

---

### Task 3: Push to Docker Hub
Add steps to:
1. Log in to Docker Hub using your secrets
2. Tag the image as `username/repo:latest` and also `username/repo:sha-<short-commit-hash>`
3. Push both tags

**Verify:** Go to Docker Hub — is your image there with both tags?

- Yes, both tags are in Dockerhub

<img width="1919" height="873" alt="Screenshot 2026-09-18 211919" src="https://github.com/user-attachments/assets/abde4d16-ca62-41e1-a93e-4ac7703aa0a6" />


---

### Task 4: Only Push on Main
Add a condition so the push step only runs on the `main` branch — not on feature branches or PRs.

Test it: push to a feature branch and verify the image is built but NOT pushed.

<img width="1919" height="879" alt="Screenshot 2026-09-18 212223" src="https://github.com/user-attachments/assets/4ced4261-76ae-4da0-92be-bb3b3f2d9599" />


---

### Task 5: Add a Status Badge
1. Get the badge URL for your `docker-publish` workflow from the Actions tab
2. Add it to your `README.md`
3. Push — the badge should show green
   
<img width="1727" height="304" alt="Screenshot 2026-09-18 212449" src="https://github.com/user-attachments/assets/16f8b42a-d399-46d4-b272-d685bec26ff0" />


---

### Task 6: Pull and Run It
1. On your local machine (or a cloud server), pull the image you just pushed
2. Run it
3. Confirm it works

Write in your notes: What is the full journey from `git push` to a running container?

[Dockerhub](https://hub.docker.com/repository/docker/tejswinim/day-45-github-practice/general)

- Yes,its woking

<img width="1602" height="470" alt="Screenshot 2026-09-18 213615" src="https://github.com/user-attachments/assets/9b5970f6-a3f2-4a5c-b702-1ecb9e02deb4" />
<img width="1919" height="974" alt="Screenshot 2026-09-18 204305" src="https://github.com/user-attachments/assets/420efec4-e89b-4ee3-85a7-983e6d881a8a" />


1. git push – Code is pushed to GitHub.

2. GitHub Actions triggers – The CI/CD workflow starts and Copleted all task or jobs.

3. Checkout code: `uses: actions/checkout@v4`

4. Login to Docker Hub: `uses: docker/login-action@v3`

5. Build Docker image using the Dockerfile.
    - If code is pushed to main: Docker image is built, tagged, and pushed to Docker Hub.
    - If pushed to other branches or PRs:Docker image is only built for testing. It is not pushed to Docker Hub.

6. Run the container: `docker run -d --name web -p 80:80 tejswinim/day-45-github-practice:sha-21a287c`

---

Happy Learning!
**TrainWithShubham**
