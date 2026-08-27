# 🐳 Day 34 – Docker Compose: Real-World Multi-Container Apps

### 90 Days of DevOps – Day 34

Today I moved beyond basic Docker Compose and built a more production-like multi-container application using Docker Compose.

## The application consists of:

- 🐍 Flask Web Application
- 🗄️ MySQL Database
-⚡ Redis Cache
- ❤️ Database Healthcheck
- 🔄 Restart Policies
- 🌐 Custom Docker Network
- 💾 Named Docker Volume
- 🏷️ Docker Labels
- 📈 Container Scaling

### 📌 What I Built

### I created a 3-tier application using Docker Compose.

                    🌐 User
                       │
                       ▼
              ┌─────────────────┐
              │   Flask Web App │
              │     Port 5000   │
              └────────┬────────┘
                       │
              ┌────────┴─────────┐
              │                  │
              ▼                  ▼
       ┌─────────────┐    ┌─────────────┐
       │    MySQL    │    │    Redis    │
       │    :3306    │    │    :6379    │
       └──────┬──────┘    └─────────────┘
              │
              ▼
       ┌─────────────┐
       │ mysql-data  │
       │ NamedVolume │
       └─────────────┘

The Flask application connects to both MySQL and Redis through a custom Docker network.

## Challenge Tasks

### 🎯Task 1: Build Your Own App Stack
Create a `docker-compose.yml` for a 3-service stack:
- A **web app** (use Python Flask, Node.js, or any language you know)
- A **database** (Postgres or MySQL)
- A **cache** (Redis)

- Run and build all images - ```docker compose up -d```

<img width="1919" height="239" alt="Screenshot 2026-08-27 130610" src="https://github.com/user-attachments/assets/f0fe60cc-4ec2-412c-8d0c-5ba6f81c9e8a" />
<img width="1918" height="966" alt="Screenshot 2026-08-27 134010" src="https://github.com/user-attachments/assets/7086d9dd-4409-446c-952b-044d555c7569" />

---

### 🐳Task 2: depends_on & Healthchecks
1. Add `depends_on` to your compose file so the app starts **after** the database
2. Add a **healthcheck** on the database service
3. Use `depends_on` with `condition: service_healthy` so the app waits for the database to be truly ready, not just started

**Test**: checking everything on docker compose **UP** & **DOWN** — does the app wait for the DB?
- **Yes**
<img width="1313" height="231" alt="Screenshot 2026-08-27 134146" src="https://github.com/user-attachments/assets/f45b7624-e9f0-4b16-bf74-d3e2f15fe7ad" />


- Postgres container starts first.
- Healthcheck waits until DB is ready.
- App container starts only after DB is healthy

---

### 🔄Task 3: Restart Policies
1. Add `restart: always` to your database service
2. Manually kill the database container — does it come back?
- **Yes** - It is back.
<img width="1296" height="241" alt="Screenshot 2026-08-27 141304" src="https://github.com/user-attachments/assets/30fe5ecf-594e-4974-9dad-feea3a764a59" />


3. Try `restart: on-failure` — how is it different?
- Did't Restart But showing like healthy.
<img width="1919" height="441" alt="Screenshot 2026-08-27 130647" src="https://github.com/user-attachments/assets/ede40aba-c57a-4032-a198-f9f54d1f1817" />


4. Write in your notes: When would you use each restart policy?

    - `restart:always` `Use When:`
         Databases,
         Backend APIs,
         Production services,
         Anything that must always run,

    - `restart:on-failure` `Use When`:
         Data processing jobs
         One-time migration scripts

---

### 🛠️Task 4: Custom Dockerfiles in Compose
1. Instead of using a pre-built image for your app, use `build:` in your compose file to build from a Dockerfile
2. Make a code change in your app
3. Rebuild and restart with one command

<img width="1919" height="239" alt="Screenshot 2026-08-27 130610" src="https://github.com/user-attachments/assets/019da5d7-e2fe-4ab9-9b46-b7f2cfb7f4e6" />
<img width="1919" height="441" alt="Screenshot 2026-08-27 130647" src="https://github.com/user-attachments/assets/478ac0c3-d8a2-4b68-b6ae-fdd0c6f9a634" />
<img width="1918" height="966" alt="Screenshot 2026-08-27 134010" src="https://github.com/user-attachments/assets/15a5bac5-b41a-45df-bb02-7cb0ca37132d" />


---

### 🌐Task 5: Named Networks & Volumes
1. Define **explicit networks** in your compose file instead of relying on the default
2. Define **named volumes** for database data
3. Add **labels** to your services for better organization
<img width="1919" height="251" alt="Screenshot 2026-08-27 134408" src="https://github.com/user-attachments/assets/396ae92e-bdcb-4760-b88d-fddb00131364" />
<img width="1096" height="183" alt="Screenshot 2026-08-27 134531" src="https://github.com/user-attachments/assets/654cada3-68d0-421f-bbca-23c3fbb826cd" />


---

### 📈Task 6: Scaling (Bonus)
1. Try scaling your web app to 3 replicas using `docker compose up --scale`

2. What happens? What breaks?

3. Write in your notes: Why doesn't simple scaling work with port mapping?
<img width="1919" height="335" alt="Screenshot 2026-08-27 141217" src="https://github.com/user-attachments/assets/11a90ee6-2d30-4a09-b921-6f716fd394b7" />


- First container started

- It binds host port 3000 = container port 3000.

- Second and third containers failed

- Status Created means Docker couldn’t start them, port-3000 - **Showing**- Like this - Bind for 0.0.0.0:3000 failed: port is already allocated.

- Docker can’t bind multiple containers to the same host port.

---

### 🧠 What I Learned
1. Docker Compose can manage complete application stacks

Instead of manually starting every container, Docker Compose allows multiple services to be defined in one file.

2. Container startup does not mean application readiness

Healthchecks help determine whether a service is actually ready.

3. depends_on controls startup order

Using:

condition: service_healthy

allows the application to wait for a healthy dependency.

4. Restart policies improve reliability

Different restart policies are useful for different types of services.

5. Named volumes provide persistence

Database data can survive container recreation.

6. Docker networks enable service discovery

Containers can communicate using service names such as:

db
redis
7. Scaling requires proper traffic routing

Simply increasing container replicas isn't enough when every replica uses the same host port.

---

### 🚀 Final Result

I successfully built a real-world multi-container application using Docker Compose with:

- ✅ Flask Web Application
- ✅ MySQL Database
- ✅ Redis Cache
- ✅ Custom Dockerfile
- ✅ Healthcheck
- ✅ depends_on
- ✅ Restart Policies
- ✅ Named Network
- ✅ Named Volume
- ✅ Docker Labels
- ✅ Application Health API
- ✅ Rebuild Workflow
- ✅ Scaling Experiment

This exercise helped me understand how Docker Compose moves from running individual containers to managing a complete application stack.

---
