# Docker Cheat Sheet 🐳

A quick and practical Docker reference covering the concepts and commands learned during Days 29–36.

---

## 1. Container Commands

### Run a container

```bash
docker run nginx
```

Creates and starts an Nginx container from the Docker Hub image.

### Run interactively

```bash
docker run -it ubuntu bash
```

Starts Ubuntu and opens an interactive Bash shell.

### Run in detached mode

```bash
docker run -d nginx
```

Runs the container in the background.

### Run with a custom name

```bash
docker run -d --name my-nginx nginx
```

Creates a container named `my-nginx`.

### List running containers

```bash
docker ps
```

Shows currently running containers.

### List all containers

```bash
docker ps -a
```

Shows running and stopped containers.

### Stop a container

```bash
docker stop my-nginx
```

Stops a running container gracefully.

### Start a stopped container

```bash
docker start my-nginx
```

Starts an existing stopped container.

### Restart a container

```bash
docker restart my-nginx
```

Stops and starts the container again.

### Remove a container

```bash
docker rm my-nginx
```

Removes a stopped container.

### Force remove a running container

```bash
docker rm -f my-nginx
```

Stops and removes the container.

### Execute a command inside a running container

```bash
docker exec -it my-nginx bash
```

Opens a shell inside the running container.

### View container logs

```bash
docker logs my-nginx
```

Displays container logs.

### Follow container logs

```bash
docker logs -f my-nginx
```

Continuously follows new log output.

### Inspect a container

```bash
docker inspect my-nginx
```

Shows detailed container configuration and networking information.

---

# 2. Port Mapping

```bash
docker run -d -p 8080:80 nginx
```

Meaning:

```text
Host Port : Container Port
8080      : 80
```

So:

```text
Browser
   |
   | http://localhost:8080
   v
Host Port 8080
   |
   v
Container Port 80
   |
   v
Nginx
```

The application listens on port `80` inside the container, while users access it through port `8080` on the host.

---

# 3. Image Commands

### List images

```bash
docker images
```

or:

```bash
docker image ls
```

Lists locally available Docker images.

### Pull an image

```bash
docker pull nginx
```

Downloads an image from Docker Hub.

### Build an image

```bash
docker build -t my-app:v1 .
```

Builds an image from the Dockerfile in the current directory.

### Tag an image

```bash
docker tag my-app:v1 username/my-app:v1
```

Creates another tag for the image, usually before pushing to Docker Hub.

### Push an image

```bash
docker push username/my-app:v1
```

Pushes the image to Docker Hub.

### Remove an image

```bash
docker rmi my-app:v1
```

Removes an image from the local machine.

### Inspect an image

```bash
docker inspect nginx
```

Shows detailed image information.

### View image history

```bash
docker history nginx
```

Shows the layers created while building the image.

---

# 4. Docker Image Layers

Docker images are made up of multiple read-only layers.

For example:

```text
Application Layer
       ↓
COPY application files
       ↓
RUN pip install
       ↓
RUN apt install
       ↓
Base Image
```

Docker uses these layers for caching.

If a Dockerfile instruction has not changed, Docker can reuse the existing layer instead of rebuilding it.

Example:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python", "app.py"]
```

If only `app.py` changes, Docker can reuse the previous layers and rebuild from the `COPY . .` instruction.

This makes builds faster.

---

# 5. Dockerfile Instructions

## FROM

```dockerfile
FROM python:3.12-slim
```

Defines the base image.

---

## WORKDIR

```dockerfile
WORKDIR /app
```

Sets the working directory inside the container.

---

## RUN

```dockerfile
RUN pip install -r requirements.txt
```

Executes a command while building the image.

`RUN` creates a new image layer.

---

## COPY

```dockerfile
COPY app.py .
```

Copies files from the build context into the image.

---

## ADD

```dockerfile
ADD app.tar.gz /app/
```

Similar to `COPY`, but has additional features such as extracting local tar archives and supporting URLs.

For normal file copying, prefer `COPY`.

---

## EXPOSE

```dockerfile
EXPOSE 5000
```

Documents the port that the application listens on.

Important:

`EXPOSE` does **not** publish the port to the host.

You still need:

```bash
docker run -p 5000:5000 my-app
```

---

## CMD

```dockerfile
CMD ["python", "app.py"]
```

Defines the default command that runs when the container starts.

---

## ENTRYPOINT

```dockerfile
ENTRYPOINT ["python"]
```

Defines the main executable for the container.

Example:

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Docker effectively runs:

```bash
python app.py
```

---

# 6. CMD vs ENTRYPOINT

### CMD

Provides a default command or default arguments.

It can easily be overridden:

```bash
docker run my-image another-command
```

### ENTRYPOINT

Defines the main executable of the container.

Example:

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

A simple way to remember:

```text
ENTRYPOINT = What should run?
CMD        = What should it run with by default?
```

---

# 7. Named Volumes

### Create a volume

```bash
docker volume create my-volume
```

Creates a Docker-managed named volume.

### List volumes

```bash
docker volume ls
```

Lists Docker volumes.

### Inspect a volume

```bash
docker volume inspect my-volume
```

Shows volume details and mount information.

### Use a named volume

```bash
docker run -d \
  --name mysql \
  -v mysql-data:/var/lib/mysql \
  mysql
```

Stores MySQL data in the Docker volume `mysql-data`.

### Remove a volume

```bash
docker volume rm my-volume
```

Removes the volume.

---

# 8. Bind Mounts

A bind mount connects a host directory directly to a container directory.

```bash
docker run -d \
  -v /home/user/app:/app \
  nginx
```

Meaning:

```text
Host:
/home/user/app

        ↓

Container:
/app
```

Changes made on the host are visible inside the container.

### Named Volume vs Bind Mount

| Type         | Managed by | Common Use                           |
| ------------ | ---------- | ------------------------------------ |
| Named Volume | Docker     | Database/application persistent data |
| Bind Mount   | User/Host  | Development and sharing host files   |

---

# 9. Docker Networks

### List networks

```bash
docker network ls
```

Shows available Docker networks.

### Create a custom network

```bash
docker network create my-network
```

Creates a custom bridge network.

### Inspect a network

```bash
docker network inspect my-network
```

Shows containers connected to the network.

### Connect a container

```bash
docker network connect my-network my-container
```

Connects an existing container to the network.

### Disconnect a container

```bash
docker network disconnect my-network my-container
```

Disconnects a container from the network.

---

# 10. Container-to-Container Communication

Containers connected to the same custom Docker network can communicate using the **container/service name**.

Example:

```text
Network: app-network

┌─────────────┐
│   backend   │
└──────┬──────┘
       │
       │ db:3306
       ↓
┌─────────────┐
│     db      │
└─────────────┘
```

The backend can connect to MySQL using:

```text
db:3306
```

Not:

```text
localhost:3306
```

Inside a container, `localhost` means **that same container**.

---

# 11. Docker Compose

Docker Compose is used to define and run multi-container applications.

Example:

```yaml
services:

  backend:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: appdb
```

### Start services

```bash
docker compose up -d
```

Starts services in detached mode.

### Build and start

```bash
docker compose up -d --build
```

Builds images and starts the services.

### List services

```bash
docker compose ps
```

Shows Compose containers.

### View logs

```bash
docker compose logs
```

Shows logs from all services.

### Follow logs

```bash
docker compose logs -f
```

Continuously follows logs.

### Logs for one service

```bash
docker compose logs -f backend
```

Shows logs for the backend service.

### Stop and remove Compose resources

```bash
docker compose down
```

Stops and removes containers and the Compose network.

### Remove volumes also

```bash
docker compose down -v
```

Stops/removes containers, networks, and Compose-managed volumes.

**Be careful:** this can delete persistent database data stored in those volumes.

### Build images

```bash
docker compose build
```

Builds Compose images.

---

# 12. Environment Variables

Instead of hardcoding configuration:

```yaml
environment:
  MYSQL_ROOT_PASSWORD: root
```

Use variables:

```yaml
environment:
  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
```

Create a `.env` file:

```env
MYSQL_ROOT_PASSWORD=strongpassword
MYSQL_DATABASE=appdb
```

Then Compose can read these values automatically.

Do not commit sensitive passwords or secrets to GitHub.

---

# 13. Docker Compose Healthcheck

A healthcheck tells Docker whether a service is actually healthy.

Example:

```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  interval: 10s
  timeout: 5s
  retries: 5
```

Docker periodically runs the healthcheck.

Possible states:

```text
starting
healthy
unhealthy
```

---

# 14. depends_on

Example:

```yaml
backend:
  depends_on:
    db:
      condition: service_healthy
```

This tells Compose to wait for the database healthcheck before starting the backend.

Important:

`depends_on` controls startup order/dependencies. It does not automatically make an application resilient to every database failure.

---

# 15. Multi-Stage Builds

Multi-stage builds use multiple `FROM` statements.

Example:

```dockerfile
# Build stage
FROM golang:1.25 AS builder

WORKDIR /app

COPY . .

RUN go build -o myapp

# Runtime stage
FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/myapp .

CMD ["./myapp"]
```

The first stage contains build tools.

The final stage contains only what is required to run the application.

### Benefits

* Smaller images
* Fewer unnecessary dependencies
* Better security
* Faster deployment
* Cleaner production images

---

# 16. Docker Hub

### Login

```bash
docker login
```

Logs in to Docker Hub.

### Tag image

```bash
docker tag my-app:v1 username/my-app:v1
```

### Push image

```bash
docker push username/my-app:v1
```

### Pull image

```bash
docker pull username/my-app:v1
```

Typical workflow:

```text
Build
  ↓
Tag
  ↓
Login
  ↓
Push
  ↓
Docker Hub
  ↓
Pull on another server
```

---

# 17. Docker Cleanup

### Remove stopped containers

```bash
docker container prune
```

### Remove unused images

```bash
docker image prune
```

### Remove unused volumes

```bash
docker volume prune
```

### Remove unused networks

```bash
docker network prune
```

### Remove unused Docker resources

```bash
docker system prune
```

### More aggressive cleanup

```bash
docker system prune -a
```

Be careful because this can remove unused images and other Docker resources.

---

# 18. Check Docker Disk Usage

```bash
docker system df
```

Shows how much disk space Docker is using.

Example:

```text
Images
Containers
Local Volumes
Build Cache
```

Useful when a server is running out of disk space.

---

# 19. Useful Inspection Commands

### Docker version

```bash
docker version
```

### Docker information

```bash
docker info
```

### Container processes

```bash
docker top my-container
```

### Container resource usage

```bash
docker stats
```

Shows CPU, memory, network and block I/O usage.

---

# 20. Practical Docker Workflow

A common application workflow:

```text
Write Application
       ↓
Create Dockerfile
       ↓
docker build
       ↓
Create Image
       ↓
docker run
       ↓
Test Application
       ↓
docker logs / docker exec
       ↓
Tag Image
       ↓
docker push
       ↓
Docker Hub
       ↓
Deploy on Server
```

---

# 21. Important Commands to Remember

```bash
docker ps
docker ps -a
docker images
docker pull IMAGE
docker build -t IMAGE:TAG .
docker run -d -p HOST:CONTAINER IMAGE
docker stop CONTAINER
docker start CONTAINER
docker rm CONTAINER
docker rmi IMAGE
docker exec -it CONTAINER bash
docker logs CONTAINER
docker volume ls
docker network ls
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f
docker system df
docker system prune
```

---

# 22. Quick Interview Revision

### Image vs Container

```text
Image     = Template / Blueprint
Container = Running instance of an image
```

### Persistent Data

```text
Container filesystem → removed with container
Named volume          → persists after container removal
```

### Container Communication

```text
Same custom network → communicate using service/container name
```

### Port Mapping

```text
-p 8080:80

8080 = Host
80   = Container
```

### Multi-Stage Build

```text
Build tools → Build application → Copy artifact → Small runtime image
```

### Docker Disk Usage

```bash
docker system df
```

### Compose Volume Removal

```bash
docker compose down
```

Removes containers and networks.

```bash
docker compose down -v
```

Also removes Compose-managed volumes.
