# Day 37 – Docker Revision & Self-Assessment 🐳

## Goal

The goal of Day 37 is to revise everything learned during Days 29–36 and make sure the important Docker concepts are understood practically.

---

# 1. Self-Assessment Checklist

I rated each topic honestly based on my current understanding.

| Topic                            | Status   | Notes                                           |
| -------------------------------- | -------- | ----------------------------------------------- |
| Run a container from Docker Hub  | ✅ Can do | Comfortable with `docker run`                   |
| List, stop and remove containers | ✅ Can do | Know `ps`, `stop`, `rm`                         |
| Remove images                    | ✅ Can do | Know `docker rmi`                               |
| Explain image layers             | 🟡 Shaky | Need more practice with caching                 |
| Explain Docker build cache       | 🟡 Shaky | Understand the basic concept                    |
| Write a Dockerfile               | ✅ Can do | Comfortable with basic instructions             |
| Explain CMD vs ENTRYPOINT        | 🟡 Shaky | Need more real-world examples                   |
| Build and tag an image           | ✅ Can do | Know `docker build` and `docker tag`            |
| Named volumes                    | 🟡 Shaky | Understand persistence but need more practice   |
| Bind mounts                      | 🟡 Shaky | Understand host-to-container mapping            |
| Docker networks                  | 🟡 Shaky | Need more practice with container communication |
| Docker Compose                   | ✅ Can do | Have practiced multi-container applications     |
| Environment variables            | 🟡 Shaky | Understand `.env` basics                        |
| Multi-stage Dockerfile           | 🟡 Shaky | Understand the concept                          |
| Push image to Docker Hub         | 🟡 Shaky | Know the workflow                               |
| Healthchecks                     | 🟡 Shaky | Need more hands-on practice                     |
| depends_on                       | 🟡 Shaky | Understand startup dependency                   |

---

# 2. Quick-Fire Questions

## Q1. What is the difference between an image and a container?

### Answer

A Docker **image** is a read-only template used to create containers.

A **container** is a running or stopped instance created from an image.

Example:

```text
nginx image
     ↓
nginx container 1
nginx container 2
nginx container 3
```

One image can be used to create multiple containers.

---

## Q2. What happens to data inside a container when you remove it?

### Answer

Data stored only inside the container's writable filesystem is normally lost when the container is removed.

For persistent data, use a Docker volume or bind mount.

Example:

```bash
docker run -v my-data:/data nginx
```

The data in `my-data` can survive container removal.

---

## Q3. How do two containers on the same custom network communicate?

### Answer

Containers connected to the same custom Docker network can communicate using their container or Compose service names.

Example:

```text
backend → db:3306
```

If the MySQL service is called `db`, the backend should connect to:

```text
db:3306
```

It should generally not use:

```text
localhost:3306
```

because `localhost` inside the backend container refers to the backend container itself.

---

## Q4. What does `docker compose down -v` do differently from `docker compose down`?

### Answer

```bash
docker compose down
```

Stops and removes the Compose containers and network.

```bash
docker compose down -v
```

Does the same and also removes the Compose-managed volumes.

This is important for databases because deleting the volume can delete persistent database data.

---

## Q5. Why are multi-stage builds useful?

### Answer

Multi-stage builds allow us to separate the build environment from the runtime environment.

For example:

```text
Builder image
    ↓
Compile application
    ↓
Copy only final application
    ↓
Small production image
```

Benefits:

* Smaller Docker images
* Faster deployment
* Fewer unnecessary packages
* Reduced attack surface
* Cleaner production containers

---

## Q6. What is the difference between COPY and ADD?

### Answer

Both can copy files into an image.

`COPY` is simpler and preferred for normal file copying.

```dockerfile
COPY app.py /app/
```

`ADD` has additional features such as extracting local tar archives.

```dockerfile
ADD app.tar.gz /app/
```

For normal application files, use:

```dockerfile
COPY
```

---

## Q7. What does `-p 8080:80` mean?

### Answer

It maps a host port to a container port.

```text
-p HOST_PORT:CONTAINER_PORT
```

Therefore:

```bash
-p 8080:80
```

means:

```text
Host port 8080
       ↓
Container port 80
```

A user can access the application through:

```text
localhost:8080
```

while the application listens on port `80` inside the container.

---

## Q8. How do you check how much disk space Docker is using?

### Answer

Use:

```bash
docker system df
```

It shows Docker disk usage for:

* Images
* Containers
* Volumes
* Build cache

---

# 3. Important Concepts

## Docker Image

An image is a package containing everything required to run an application:

```text
Application
Dependencies
Libraries
Configuration
Base OS files
```

---

## Docker Container

A container is an isolated environment created from an image.

```text
Image
  ↓
Container
  ↓
Application running
```

---

## Docker Volume

A volume provides persistent storage outside the container's writable filesystem.

```text
Container
    ↓
Docker Volume
    ↓
Persistent Data
```

Useful for databases such as MySQL and PostgreSQL.

---

## Docker Network

A Docker network allows containers to communicate with each other.

```text
backend ──────┐
              │
              ↓
        app-network
              ↑
              │
db ───────────┘
```

The backend can communicate with the database using:

```text
db:3306
```

---

# 4. Dockerfile Example

A simple Python application:

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

### Explanation

```text
FROM
↓
Select base image

WORKDIR
↓
Set application directory

COPY
↓
Copy files into image

RUN
↓
Install dependencies

EXPOSE
↓
Document application port

CMD
↓
Start application
```

---

# 5. Docker Compose Example

A simple backend + database application:

```yaml
services:

  backend:
    build: .
    ports:
      - "5000:5000"
    environment:
      DB_HOST: db
      DB_PORT: 3306
    depends_on:
      db:
        condition: service_healthy

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: appdb
    volumes:
      - mysql-data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  mysql-data:
```

### Architecture

```text
                 Docker Host
                     |
          ┌──────────┴──────────┐
          │                     │
      Backend                 MySQL
      :5000                   :3306
          │                     │
          └──── app-network ────┘
                    |
              mysql-data
                 volume
```

---

# 6. Multi-Stage Build Example

```dockerfile
FROM golang:1.25 AS builder

WORKDIR /app

COPY . .

RUN go build -o app

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/app .

CMD ["./app"]
```

The first stage contains the compiler and build tools.

The second stage contains only the application required to run.

---

# 7. Practical Docker Workflow

The normal workflow is:

```text
1. Write application
       ↓
2. Create Dockerfile
       ↓
3. Build image
       ↓
4. Run container
       ↓
5. Test application
       ↓
6. Check logs
       ↓
7. Fix issues
       ↓
8. Tag image
       ↓
9. Push to Docker Hub
       ↓
10. Deploy
```

Commands:

```bash
docker build -t my-app:v1 .

docker run -d -p 8080:80 my-app:v1

docker ps

docker logs my-app

docker tag my-app:v1 username/my-app:v1

docker push username/my-app:v1
```

---

# 8. Weak Areas to Revisit

For additional hands-on practice, focus on these two areas:

## Weak Area 1 – Docker Networking

Practice:

```bash
docker network create app-network

docker run -d \
  --name web \
  --network app-network \
  nginx
```

Run another container:

```bash
docker run -it \
  --name test \
  --network app-network \
  busybox
```

Inside the `test` container, try:

```bash
ping web
```

The important concept is:

```text
Same custom network
        ↓
Containers can communicate
        ↓
Use container/service name
```

---

## Weak Area 2 – Docker Volumes

Create a volume:

```bash
docker volume create test-volume
```

Run a container:

```bash
docker run -it \
  --name volume-test \
  -v test-volume:/data \
  ubuntu bash
```

Inside the container:

```bash
echo "Docker persistent data" > /data/test.txt
```

Exit:

```bash
exit
```

Remove the container:

```bash
docker rm volume-test
```

Create another container using the same volume:

```bash
docker run -it \
  -v test-volume:/data \
  ubuntu bash
```

Check:

```bash
cat /data/test.txt
```

The data should still exist because it was stored in the Docker volume.

---

# 9. Commands I Should Remember for Interviews

```bash
docker ps
docker ps -a
docker images
docker pull nginx
docker build -t my-app:v1 .
docker run -d -p 8080:80 nginx
docker stop container
docker rm container
docker rmi image
docker exec -it container bash
docker logs container
docker volume ls
docker volume inspect volume
docker network ls
docker network inspect network
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f
docker system df
docker system prune
```

---

# 10. Final Day-37 Summary

The most important Docker concepts learned so far are:

### Container

A running instance of an image.

### Image

A read-only template used to create containers.

### Dockerfile

A file containing instructions for building an image.

### Volume

Used for persistent data.

### Network

Allows containers to communicate.

### Docker Compose

Used to define and manage multi-container applications.

### Multi-stage Build

Used to create smaller and cleaner production images.

### Docker Hub

A registry used to store and share Docker images.

### Healthcheck

Used to determine whether a container/service is healthy.

### depends_on

Defines service dependencies in Docker Compose.

---

# 11. Day-37 Learning Outcome

After completing this revision, I should be able to:

* Run and manage Docker containers.
* Build custom Docker images.
* Write a basic Dockerfile.
* Explain Docker image layers and caching.
* Use volumes for persistent storage.
* Use bind mounts during development.
* Create Docker networks.
* Understand container-to-container communication.
* Create multi-container applications using Docker Compose.
* Use environment variables in Compose.
* Create multi-stage Dockerfiles.
* Push images to Docker Hub.
* Configure healthchecks.
* Understand `depends_on`.
* Troubleshoot basic Docker issues using logs, inspect, stats and disk-usage commands.

---

## Day 37 Status

**Docker fundamentals revised and consolidated. 🐳**

The next step is to continue building on these concepts with more practical Docker and DevOps work.
