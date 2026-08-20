# 🐳Day 29 – Introduction to Docker

### 🐳Task 1:

### 🐳What is Docker?

- Docker is an open-source platform that enables developers to build, ship, and run applications inside lightweight, isolated environments called containers.

### ❓Why we need?
- You can build locally,deploy to the cloud and run anywhere on any server.
- Shares the host kernel, making them much more efficient in therms of system resources than vitual machine.
- Makes collaboration easier, same environment for everyone.
- No version mismatch issues.

### ⚔️Containers vs Virtual Machines

| Feature | Virtual Machines (VMs) | Containers |
|----------|------------------------|------------|
| **Virtualization Level** | Hardware-level virtualization | OS-level virtualization |
| **Architecture** | Includes full guest OS + hypervisor | Shares host OS kernel |
| **Size** | Large (GBs) | Small (MBs) |
| **Startup Time** | Slow (minutes) | Fast (seconds) |
| **Performance** | Slower due to OS overhead | Faster, lightweight |
| **Isolation** | Strong (separate OS per VM) | Process-level isolation |
| **Resource Usage** | High CPU, RAM, Storage usage | Efficient resource usage |
| **Portability** | Less portable | Highly portable |
| **Management** | Complex (manage full OS) | Simple (manage app + dependencies) |
| **Best For** | Legacy apps, multiple OS environments | Microservices, CI/CD, cloud-native apps |

### 🏗️Docker architecture

<img width="474" height="371" alt="image" src="https://github.com/user-attachments/assets/7b78b23a-bc77-40f8-b08b-899da991f6af" />

---

### 💻Docker Client

### What it is ?
The Docker client is the command-line interface (CLI) used to interact with Docker. It acts as the command center.

### How it works ?
You type commands in the Docker client, and it sends those requests to the Docker daemon, which performs the actual work.

### Example Commands
- `docker build`
- `docker run`
- `docker pull`
- `docker push`

---

### ⚙️Docker Daemon

### What it is ?
The Docker daemon (`dockerd`) is the background service that manages Docker objects such as images, containers, networks, and volumes.

### How it works ?
The daemon:
- Listens for Docker API requests from the Docker client
- Builds images
- Runs and manages containers
- Handles networking and storage

---

### ☁️Docker Hub

### What it is
Docker Hub is a cloud-based public registry for Docker images.

### How it works
It works like an app store for container images. 

You can:
- **Pull** images created by others
- **Push** your own images

### Usage
When you need an image to create a container, you can pull it from Docker Hub.

---

### 🗄️Docker Registry

### What it is ?
+ A Docker registry is a system that stores and distributes Docker images. Docker Hub is the most popular public registry,
but you can also create private registries.

Like- Username & password as a registry.

### How it works ?
Registries:
- Store Docker images
- Allow users to pull images
- Allow users to push images

Private registries are commonly used by companies to securely store internal application images.

---

### 🛠️Task 2: Install Docker
1. Install Docker on your machine (or use a cloud instance)
<img width="1915" height="739" alt="Screenshot 2026-08-20 140955" src="https://github.com/user-attachments/assets/24e6806e-3bc6-421b-81c1-b943330cb965" />

2. Verify the installation
<img width="1410" height="642" alt="Screenshot 2026-08-20 141736" src="https://github.com/user-attachments/assets/2c095261-c207-45b5-965b-0da37e5ddd57" />

3. Run the `hello-world` container: docker run hello-world
<img width="1410" height="642" alt="Screenshot 2026-08-20 141736" src="https://github.com/user-attachments/assets/2c095261-c207-45b5-965b-0da37e5ddd57" />

4. Read the output carefully — it explains what just happened
+ Docker didn’t find the hello-world image on your machine.
+ It downloaded (pulled) it from Docker Hub.
+ Docker created a container from that image.
+ The container ran a small program that printed “Hello from Docker!”
+ The container exited.

---

### 🐳Task 3: Run Real Containers
1. Run an **Nginx** container and access it in your browser: **docker run -d -p 80:80 nginx <host_port>:<container_port>**
<img width="1318" height="345" alt="Screenshot 2026-08-20 141940" src="https://github.com/user-attachments/assets/bb2d1802-e8ec-4734-85ca-dca1fd13fd05" />
<img width="1919" height="680" alt="Screenshot 2026-08-20 142134" src="https://github.com/user-attachments/assets/3cee8b06-ff61-476a-a464-0d7c9fc9273c" />


2. Run an **Ubuntu** container in interactive mode — explore it like a mini Linux machine: **docker run -it ubuntu**
<img width="1890" height="731" alt="Screenshot 2026-08-20 142351" src="https://github.com/user-attachments/assets/0e8061f0-4754-42b8-a3e4-e18a1470a6ff" />

3. List all running containers: **docker ps**
4. List all containers (including stopped ones): **docker ps -a**
<img width="1913" height="245" alt="Screenshot 2026-08-20 142715" src="https://github.com/user-attachments/assets/bab3f4c2-182d-43fa-afa2-d86e37e36aca" />

5. Stop and remove a container: **docker stop && docker rm**
<img width="1247" height="186" alt="Screenshot 2026-08-20 142746" src="https://github.com/user-attachments/assets/e620c295-b688-4838-ab91-bbc64d728ec2" />

---

### 🔍Task 4: Explore
1. Run a container in **detached mode** — **detached mode : detach mode run containers in background mode**
<img width="1140" height="54" alt="Screenshot 2026-08-20 142937" src="https://github.com/user-attachments/assets/ca5d497b-18b2-4877-9068-00ca4fc42f16" />

2. Give a container a custom **name: docker run -d --name web httpd**
<img width="1287" height="406" alt="Screenshot 2026-08-20 142925" src="https://github.com/user-attachments/assets/e6ed7c6a-c9af-4a43-afc6-8175064f11a8" />

3. Map a **port** from the container to your host: **docker run -d --name web2 -p 80:80 nginx <host_port>:<container_port>**
<img width="1899" height="185" alt="Screenshot 2026-08-20 143049" src="https://github.com/user-attachments/assets/07d0b31c-dcda-40ed-af10-1e637fdac6db" />

4. Check **logs** of a running container: **docker logs**
<img width="1893" height="568" alt="Screenshot 2026-08-20 143159" src="https://github.com/user-attachments/assets/6fb17965-37f8-46a8-ba0f-bf42d8bb8496" />

5. Run a command **inside** a running container: **docker exec -it**
<img width="1919" height="463" alt="Screenshot 2026-08-20 143315" src="https://github.com/user-attachments/assets/f653afcc-236f-4032-ab70-e731171f2889" />


## 🚀Why This Matters for DevOps
+ Docker is the foundation of modern deployment. 
+ Every CI/CD pipeline, Kubernetes cluster, and microservice architecture starts with containers. 
+ Today you took the first step.

---
## 🌟 My Key Takeaway

Docker helped me understand how applications can be packaged with their dependencies and run consistently across different environments.

Today was my first hands-on step into containerization, and this knowledge will become the foundation for learning Dockerfiles, Docker Compose, CI/CD, and Kubernetes. 🚀🐳

## 🎯 Day 29 Completed!

Learn → Practice → Break → Fix → Repeat 🔄

- 🐳 One container today.
- ☸️ Kubernetes tomorrow.
- 🚀 DevOps journey continues!

---
