# 🐳Day 33 – Docker Compose: Multi-Container Basics

## 🎯Challenge Tasks

### 🔹Task 1: Install & Verify
1. Check if Docker Compose is available on your machine
2. Verify the version
<img width="763" height="92" alt="Screenshot 2026-08-25 113608" src="https://github.com/user-attachments/assets/eacc03c4-fb70-4b11-8ba0-650f48dddcf5" />

---

### 🚀Task 2: Your First Compose File
1. Create a folder `compose-basics`
2. Write a `docker-compose.yml` that runs a single **Nginx** container with port mapping
3. Start it with `docker compose up`
4. Access it in your browser


    [Dockerfile](compose-basics/Dockerfile)

   [Compose file](compose-basics/docker-compose.yml)

<img width="1773" height="674" alt="Screenshot 2026-08-25 114822" src="https://github.com/user-attachments/assets/2b9656d2-ac4b-45e7-93b4-4eabf2d85de3" />
<img width="1911" height="971" alt="Screenshot 2026-08-25 114914" src="https://github.com/user-attachments/assets/9d0b4b1f-a987-4baf-9b6d-341a87b7f4bf" />

5. Stop it with `docker compose down`
<img width="1861" height="251" alt="Screenshot 2026-08-25 115134" src="https://github.com/user-attachments/assets/cba847b6-ba9f-4f1b-a139-2972353b18cd" />
<img width="1918" height="865" alt="Screenshot 2026-08-25 115111" src="https://github.com/user-attachments/assets/135d1efe-8972-4107-b04a-9c199f846985" />

---

### 🐳Task 3: Two-Container Setup
Write a `docker-compose.yml` that runs:
- A **WordPress** container
- A **MySQL** container

They should:
- Be on the same network (Compose does this automatically)
- MySQL should have a named volume for data persistence
- WordPress should connect to MySQL using the service name

Start it, access WordPress in your browser, and set it up.

**Verify:** Stop and restart with `docker compose down` and `docker compose up` — is your WordPress data still there?
[Compose file](wordpress-mysql/docker-compose.yml)

<img width="796" height="742" alt="Screenshot 2026-08-25 115346" src="https://github.com/user-attachments/assets/249068ad-47bb-4bec-94d5-0516da9a3d6e" />
<img width="1889" height="159" alt="Screenshot 2026-08-25 115608" src="https://github.com/user-attachments/assets/76fdf23e-cf96-49f6-9502-3b1b013cffcd" />
<img width="1919" height="980" alt="Screenshot 2026-08-25 115743" src="https://github.com/user-attachments/assets/dfb8efd8-bebd-48bd-9f88-7c6853719fe4" />
<img width="1919" height="964" alt="Screenshot 2026-08-25 115851" src="https://github.com/user-attachments/assets/0ecb0fe6-01e2-42e4-80fd-1dd0f9252475" />
<img width="1768" height="776" alt="Screenshot 2026-08-25 120126" src="https://github.com/user-attachments/assets/2412f47d-8b26-4d2d-8b9e-12d8b2e8ca00" />

- Yes Wordpress data is available there.
<img width="1293" height="890" alt="Screenshot 2026-08-25 120208" src="https://github.com/user-attachments/assets/dbdee330-9325-4e90-93be-c17b5cfe6a8d" />

---

### ⚙️Task 4: Compose Commands
Practice and document these:
1. Start services in **detached mode**

```
docker compose up -d
```
<img width="1213" height="183" alt="Screenshot 2026-08-25 120351" src="https://github.com/user-attachments/assets/768ff5bd-da30-4898-a7c2-b0d76a068dcd" />


2. View running services
```
docker compose ps
```
<img width="1919" height="139" alt="Screenshot 2026-08-25 120400" src="https://github.com/user-attachments/assets/1acb3d7f-bf75-4975-ba77-f01bd9e72f8f" />

3. View **logs** of all services
```docker compose logs db && docker compose logs wordpress```

<img width="1919" height="734" alt="Screenshot 2026-08-25 120432" src="https://github.com/user-attachments/assets/328837c6-caec-4c92-a83b-b13d71acf7f3" />
<img width="1918" height="338" alt="Screenshot 2026-08-25 120521" src="https://github.com/user-attachments/assets/63577198-54ac-4749-977b-ac1fba3e3e02" />

5. View logs of a **specific** service

```docker compose logs db```
<img width="1919" height="512" alt="Screenshot 2026-08-25 120535" src="https://github.com/user-attachments/assets/31c1b2c1-d172-4888-b67e-20efcc7c7b66" />


6. **Stop** services without removing
```docker compose stop```
<img width="1499" height="625" alt="Screenshot 2026-08-25 120617" src="https://github.com/user-attachments/assets/5f7fce05-04f5-4d90-bd87-d2ed50e11ca3" />


8. **Remove** everything (containers, networks)
```docker compose down```
<img width="1352" height="340" alt="Screenshot 2026-08-25 120635" src="https://github.com/user-attachments/assets/b734f4cf-c192-4e10-8e78-ca696e0954a8" />


10. **Rebuild** images if you make a change
```docker compose up --build```

---

### 🔐Task 5: Environment Variables
1. Add environment variables directly in your `docker-compose.yml`
2. Create a `.env` file and reference variables from it in your compose file
3. Verify the variables are being picked up
<img width="914" height="689" alt="Screenshot 2026-08-25 121622" src="https://github.com/user-attachments/assets/d57714e5-7740-4cf2-8436-cce13834e485" />

<img width="1919" height="844" alt="Screenshot 2026-08-25 121724" src="https://github.com/user-attachments/assets/df46c082-33de-4be3-acc9-7eaccc416755" />
<img width="1857" height="160" alt="Screenshot 2026-08-25 121806" src="https://github.com/user-attachments/assets/842a9b33-8494-495a-9fc7-7c8b2accfc68" />

---
### 📚 Key Learnings
- 🐳 Docker Compose simplifies multi-container application management.
- 🔗 Compose automatically creates a network for services.
- 🌐 Services can communicate using their service names.
- 💾 Named volumes provide persistent data storage.
- ⚙️ Environment variables make Compose configurations flexible.
- 📋 docker compose logs helps troubleshoot containers.
- 🛑 docker compose stop stops services without removing them.
- 🧹 docker compose down removes containers and networks.
- 🔨 docker compose up --build rebuilds images when changes are made.

### 🚀 Day 33 Completed!

Another step forward in my #90DaysOfDevOps journey. 🐳💻

 ---
Happy Learning!
**TrainWithShubham**
