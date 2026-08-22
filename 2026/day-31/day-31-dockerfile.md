# 🐳Day 31 – Dockerfile: Build Your Own Images

## 🎯Task
Today's goal is to **write Dockerfiles and build custom images**.
Today I learned how to:

- 📝 Write a Dockerfile
- 🏗️ Build a custom Docker image
- 📦 Run containers from custom images
- ⚙️ Understand Dockerfile instructions
- 🔄 Understand CMD vs ENTRYPOINT
- 🌐 Build a simple Nginx web image
- 🚫 Use .dockerignore
- ⚡ Optimize Docker builds using cache

## Challenge Tasks

### 🏗️Task 1: Your First Dockerfile
1. Create a folder called `my-first-image`
2. Inside it, create a `Dockerfile` that:
   - Uses `ubuntu` as the base image
   - Installs `curl`
   - Sets a default command to print `"Hello from my custom image!"`
3. Build the image and tag it `my-ubuntu:v1`
4. Run a container from your image
<img width="662" height="332" alt="Screenshot 2026-08-22 143728" src="https://github.com/user-attachments/assets/3fb6e7b9-79a0-4cf1-8b54-01f3e8d43cb2" />
<img width="1919" height="573" alt="Screenshot 2026-08-22 144031" src="https://github.com/user-attachments/assets/173c9313-8578-44d6-bafe-2dfd167b64ff" />

5. Run a container from your image

<img width="947" height="86" alt="Screenshot 2026-08-22 144200" src="https://github.com/user-attachments/assets/d106ea6c-d0da-456c-a4f1-d3de065e5b54" />


**Verify:** The message prints on `docker run`

### 🐳 Docker Errors Faced and debugged

❌ Error 1: [echo: not found
 ``/bin/sh: 1: [echo: not found ``

Reason :

 - Image  ``(my-ubuntu:v1) `` was built earlier with an  ``incorrect CMD ``

 - Dockerfile was fixed later, but image was  ``not rebuilt ``

 - Docker kept using the old broken image

Fix :

docker build -t my-ubuntu:v2 .
docker run my-ubuntu:v2

Key Learning :

Docker images are  ``immutable — always rebuild after Dockerfile changes. ``

 ❌ Error 2: ``Wrong Dockerfile Name``

 Docker only auto-detects a file named exactly Dockerfile
(case-sensitive).
Fix: If the file is named incorrectly (e.g. DockerFile, dockerfile, Dockerfile-dev), Docker will fail to build unless explicitly     told which file to use.

❌ Error 3:  ``Container name already in use ``

Conflict. The container name "/first-container" is already in use
Reason :
 - A container named first-container already exists
 - Docker does not allow  ``duplicate container names ``
Fix :
docker rm first-container
or
`docker run --name first-container-v2 my-ubuntu:v1`

Key Learning :
Container names must be unique.

---

### 🧱Task 2: Dockerfile Instructions
Create a new Dockerfile that uses **all** of these instructions:
- `FROM` `ubuntu`
Uses lightweight ubuntu image based on Alpine Linux.

- `WORKDIR` `/app`
Sets /app as working directory inside container.

- `COPY hello.txt .`
Copies everything from your my-first-image folder into /app inside container.


- `EXPOSE 8080`
Documents that container uses port 8080.

- `CMD ["cat", "hello.txt"]`
<img width="770" height="367" alt="Screenshot 2026-08-22 144651" src="https://github.com/user-attachments/assets/e12b9208-a9f1-4dfc-a1b0-0cac4439569a" />
<img width="1728" height="584" alt="Screenshot 2026-08-22 150130" src="https://github.com/user-attachments/assets/363cdd6d-156f-47e5-b11e-409e23cd99d2" />

---

### 🔄Task 3: CMD vs ENTRYPOINT
1. Create an image with `CMD ["echo", "hello"]` — run it, then run it with a custom command. What happens?
<img width="430" height="96" alt="Screenshot 2026-08-22 150239" src="https://github.com/user-attachments/assets/07fb5ddc-3ecd-452d-a5b1-773ae7b523a0" />
<img width="1919" height="386" alt="Screenshot 2026-08-22 150400" src="https://github.com/user-attachments/assets/c897cea1-64c1-486f-8e70-117e2c3e1b2c" />
<img width="1309" height="94" alt="Screenshot 2026-08-22 150438" src="https://github.com/user-attachments/assets/6b2d198b-211c-4555-a990-0450aa49b2d8" />

- Run without arguments: The container runs the default command echo hello and outputs:

`hello`

- Run with a custom command: When you run the container with a custom command (e.g., echo "custom command"), the custom command completely overrides the CMD, so the output is:

`custom command`

2. Create an image with `ENTRYPOINT ["echo"]` — run it, then run it with additional arguments. What happens?

<img width="418" height="113" alt="Screenshot 2026-08-22 150544" src="https://github.com/user-attachments/assets/4b1a0f83-0290-4550-820a-07a6582ffd94" />
<img width="1919" height="339" alt="Screenshot 2026-08-22 150827" src="https://github.com/user-attachments/assets/6b1f4ff0-362e-4e16-8a8b-8b89604a334a" />
<img width="1140" height="90" alt="Screenshot 2026-08-22 150947" src="https://github.com/user-attachments/assets/e9955928-5617-43f9-961b-6b33c7edac31" />


- Run without arguments: The container runs echo with no arguments,resulting in a blank line (no output).

- Run with additional arguments: When you pass arguments (e.g., hello-world), they are appended to the ENTRYPOINT, so it runs echo hello-world and outputs:

`hello-world`

3. Write in your notes: When would you use CMD vs ENTRYPOINT?

- Use CMD when you want to provide a default command that can be changed easily when you run the container.
- Use ENTRYPOINT when you want to set a fixed command that always runs.

## CMD vs ENTRYPOINT — Quick Memory Table

| Aspect | CMD | ENTRYPOINT |
|------|-----|-----------|
| Purpose | Provides a default command | Defines the main executable |
| Overridden by `docker run` | ✅ Yes | ❌ No (unless `--entrypoint`) |
| User input treated as | New command | Arguments to the executable |
| Flexibility | High | Low (fixed behavior) |
| Best use case | Dev, utility, base images | Apps, CLIs, production services |
| Common example | `CMD ["bash"]` | `ENTRYPOINT ["nginx"]` |
| If both are used | CMD is replaced | ENTRYPOINT always runs |
| Interview memory line | “CMD is a default” | “ENTRYPOINT is mandatory” |

### One-Line Memory Trick
**CMD = suggestion | ENTRYPOINT = rule**

---

### 🌐Task 4: Build a Simple Web App Image
1. Create a small static HTML file (`index.html`) with any content

2. Write a Dockerfile that:
   - Uses `nginx:alpine` as base
   - Copies your `index.html` to the Nginx web directory
3. Build and tag it `my-website:v1`
4. Run it with port mapping and access it in your browser
<img width="1762" height="626" alt="Screenshot 2026-08-22 151514" src="https://github.com/user-attachments/assets/55e37983-c0ac-4081-b135-5f5e6f6ad69f" />
<img width="1617" height="474" alt="Screenshot 2026-08-22 151653" src="https://github.com/user-attachments/assets/6864827f-ec43-4df8-b0ea-018d0e733c72" />

---

### 🚫Task 5: .dockerignore
1. Create a `.dockerignore` file in one of your project folders
2. Add entries for: `node_modules`, `.git`, `*.md`, `.env`
3. Build the image — verify that ignored files are not included
<img width="1919" height="692" alt="Screenshot 2026-08-22 152205" src="https://github.com/user-attachments/assets/dfb65081-c591-475c-989f-039deb52f9c1" />

- node_modules, .git, any .md files, and .env are not present.
- index.html or required files are present.

---

### ⚡Task 6: Build Optimization

1. Build an image, then change one line and rebuild — notice how Docker uses **cache**
<img width="635" height="229" alt="Screenshot 2026-08-22 154450" src="https://github.com/user-attachments/assets/b439af83-fb45-4701-bd9d-f037244bf53e" />

<img width="1833" height="397" alt="Screenshot 2026-08-22 152905" src="https://github.com/user-attachments/assets/e322c462-04a4-45d1-858c-0d7cdbca7c88" />

Observation: The image is built successfully and all layers are created.

Change one line and rebuild: change in app.txt



<img width="1825" height="384" alt="Screenshot 2026-08-22 153009" src="https://github.com/user-attachments/assets/5b1f890b-edbf-42ca-ab7f-80664cfad39e" />


Observation:
Docker reused cached layers for: Base image, Working directory, Dependency installation.

3. Write in your notes: Why does layer order matter for build speed?
- Docker builds images in layers and caches each layer.
- If a layer changes, Docker Rebuilds that layer and all layers after it.
- By placing:
    - Rarely changing files (dependencies) first.
    - Frequently changing files (source code) last.
- Docker can reuse cached layers,resulting in faster rebuilds.

## Docker Layer Order and Build Speed
Why Layer Order Matters for Build Speed?
- Docker uses caching to speed up builds. When you build an image, Docker checks each instruction in your Dockerfile:
- Caching Logic: If a layer hasn't changed, Docker reuses the cached version. However, once a layer is modified, all subsequent layers must be rebuilt from scratch.
- Optimal Order: You should place infrequently changed instructions (like installing OS packages or dependencies) at the top and frequently changed instructions (like your source code) at the bottom.
- Result: This ensures that when you edit your code, Docker only has to rebuild the very last layer, keeping builds fast.

---
## 🎯 Day 31 Docker Flow

```text
📝 Dockerfile
      ↓
🏗️ docker build
      ↓
🖼️ Custom Docker Image
      ↓
🚀 docker run
      ↓
📦 Container
      ↓
🔎 Test / Inspect
      ↓
⚡ Optimize
      ↓
🧹 Cleanup
```

 ---
 
`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
