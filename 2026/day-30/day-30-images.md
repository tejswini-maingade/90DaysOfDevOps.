# 🐳 Day 30 – Docker Images & Container Lifecycle

## 🎯Task
Today's goal is to **understand how images and containers actually work**.

You will:
- Learn the relationship between images and containers
- Understand image layers and caching
- Master the full container lifecycle

---

### 🖼️Task 1: Docker Images
1. Pull the `nginx`, `ubuntu`, and `alpine` images from Docker Hub
<img width="1919" height="693" alt="Screenshot 2026-08-22 124403" src="https://github.com/user-attachments/assets/7fddf928-0125-47fb-aa51-f215b0b48c65" />

2. List all images on your machine — note the sizes
<img width="1305" height="206" alt="Screenshot 2026-08-22 124515" src="https://github.com/user-attachments/assets/fb14f873-8f7c-4634-989b-13e9ee93e924" />

| Image         | Disk Usage | Content Size |
    | ------------- | ---------- | ------------ |
    | alpine:latest | 13.1MB     | 8.4MB       |
    | nginx:latest  | 240MB      | 162MB       |
    | ubuntu:latest | 119MB      | 100MB       |

    **Local Size(Disk usage) is actual image size**

    **Transfer Size(Content Size) is amount of data used when pulling the image over a network**

3. Compare `ubuntu` vs `alpine` — why is one much smaller?

- `Ubuntu` is a full-featured Linux distribution, while `Alpine` is a minimal distribution optimized for containers. 
- `Ubuntu` is larger because it includes GNU tools and glibc, whereas `Alpine` uses BusyBox and musl, making it much smaller.

4. Inspect an image — what information can you see?
<img width="843" height="721" alt="Screenshot 2026-08-22 124706" src="https://github.com/user-attachments/assets/fc1a8894-575d-481e-b6af-959c7e646243" />
<img width="831" height="715" alt="Screenshot 2026-08-22 124720" src="https://github.com/user-attachments/assets/541ff4ee-202f-4dec-844c-c1e7a7a427d9" />

    - Image ID: sha256:f075e3f9498646....
    - Image: nginx:latest
    - Exposed Port: 80/tcp (HTTP)
    - Repository: docker.io/library/nginx
    - Environment variable
    - NGINX Version: 1.31.4
    - ENTRYPOINT
    - CMD
    - Lables, maintainer
    - Filesystem | Uses layered filesystem | 7 layers

5. Remove an image you no longer need
<img width="1629" height="404" alt="Screenshot 2026-08-22 124857" src="https://github.com/user-attachments/assets/dbcd626a-c70c-429b-9d1b-77f5e3b85bc7" />

---

### 🧱Task 2: Image Layers
1. Run `docker image history nginx` — what do you see?
<img width="1529" height="470" alt="Screenshot 2026-08-22 125012" src="https://github.com/user-attachments/assets/686e3875-c2ff-48a4-b8cf-a9707420f91c" />

- A list of instructions used to build the nginx image (e.g., CMD, EXPOSE, ENTRYPOINT, COPY, RUN, ENV, LABEL) Each instruction corresponds to a layer.
  
2. Each line is a **layer**. Note how some layers show sizes and some show 0B
+ Layers with a size (MB or kB) were created by instructions that modify the filesystem,such as RUN, COPY, or ADD.
+ Layers showing 0B were created by instructions that only change metadata, such as ENV, CMD, EXPOSE, LABEL, or ENTRYPOINT.These do not change the filesystem.

3. Write in your notes: What are layers and why does Docker use them?
- Docker layers are read-only filesystem snapshots created by each instruction in a Dockerfile.
- Docker uses layers because:
    - They allow build caching (faster builds)
    - They allow images to share
 common layers (saves storage).
    - They make image downloads faster (only new layers are pulled)

---

### 🔄Task 3: Container Lifecycle
Practice the full lifecycle on one container:
1. **Create** a container (without starting it)
2. **Start** the container
3. **Pause** it and check status
4. **Unpause** it
5. **Stop** it
6. **Restart** it
7. **Kill** it
8. **Remove** it
<img width="1582" height="294" alt="Screenshot 2026-08-22 125359" src="https://github.com/user-attachments/assets/eed05bc3-98de-4447-9ebb-9348ed1be14d" />
<img width="672" height="184" alt="Screenshot 2026-08-22 125405" src="https://github.com/user-attachments/assets/ca57ea3d-47f5-4877-808a-46081f5686ad" />
<img width="1919" height="822" alt="Screenshot 2026-08-22 125700" src="https://github.com/user-attachments/assets/990d0f48-be52-492f-ae33-3ab6f801913f" />
<img width="1362" height="239" alt="Screenshot 2026-08-22 125752" src="https://github.com/user-attachments/assets/e71ebbda-cd80-4dd1-bbb0-c37462d9f073" />


---

### 🏃Task 4: Working with Running Containers
1. Run an Nginx container in detached mode
2. View its **logs**
3. View **real-time logs** (follow mode)

<img width="1212" height="496" alt="Screenshot 2026-08-22 130117" src="https://github.com/user-attachments/assets/d1ea4722-4ccc-4a4a-bcd4-d7c54cb4f53b" />

4. **Exec** into the container and look around the filesystem
<img width="1066" height="679" alt="Screenshot 2026-08-22 130246" src="https://github.com/user-attachments/assets/b04c7992-25a2-436b-876f-f03d447d81e3" />

5. Run a single command inside the container without entering it
<img width="1239" height="359" alt="Screenshot 2026-08-22 130447" src="https://github.com/user-attachments/assets/a005c8b9-578f-4796-8bde-4a555775a7a2" />

6. **Inspect** the container — find its IP address, port mappings, and mounts
<img width="961" height="713" alt="Screenshot 2026-08-22 130523" src="https://github.com/user-attachments/assets/04d47cac-7f5d-42d3-8573-b1ebaa2c1e08" />

**IP address**
<img width="1035" height="293" alt="Screenshot 2026-08-22 131641" src="https://github.com/user-attachments/assets/508bf0ff-9f20-49d2-a155-9dc6638d452d" />


**port mappings**
<img width="850" height="248" alt="Screenshot 2026-08-22 131702" src="https://github.com/user-attachments/assets/e1c06db2-6f1d-42b4-a4d6-d1c6d7022a4b" />

**mount**
<img width="373" height="183" alt="Screenshot 2026-08-22 131731" src="https://github.com/user-attachments/assets/afcaf998-1699-4113-afa1-b48313590317" />

---

### 🧹Task 5: Cleanup
1. Stop all running containers in one command
2. Remove all stopped containers in one command
3. Remove unused images
<img width="1919" height="830" alt="Screenshot 2026-08-22 132110" src="https://github.com/user-attachments/assets/46adaf76-1b7a-4aa8-8d04-ca1bd47268b4" />
<img width="866" height="161" alt="Screenshot 2026-08-22 132136" src="https://github.com/user-attachments/assets/b039be12-e757-4861-bf01-e7629ad785d6" />

4. Check how much disk space Docker is using
- 0B of disk space because all images and containers were removed successfully.

---

## 🧠 Day 30 Key Takeaways
### 🖼️ Docker Image

An image is a read-only template used to create containers.

### 📦 Container

A container is a runnable instance created from a Docker image.

### 🧱 Image Layers

Docker images are built from multiple layers, which enable caching, sharing, and efficient storage.

### 🔄 Container Lifecycle
🆕 Create
 ↓
▶️ Start
 ↓
⏸️ Pause
 ↓
▶️ Unpause
 ↓
🛑 Stop
 ↓
🔄 Restart
 ↓
💀 Kill
 ↓
🗑️ Remove

## ⭐ Important Commands
``` - docker images
- docker image inspect nginx
- docker image history nginx

- docker ps
- docker ps -a

- docker create
- docker start
- docker pause
- docker unpause
- docker stop
- docker restart
- docker kill
- docker rm

- docker logs
- docker logs -f
- docker exec
- docker inspect

- docker system df
- docker image prune
```


---


### 🚀 Day 30 Completed!

Today I learned how Docker images are built using layers, how containers move through their complete lifecycle, and how to inspect, troubleshoot, and clean up containers.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham

🎯 Happy Learning!

---


🙏 Thank you, TrainWithShubham, for the continuous learning journey and hands-on DevOps practice.
