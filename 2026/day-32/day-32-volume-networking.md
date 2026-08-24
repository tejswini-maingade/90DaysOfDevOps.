# 🐳Day 32 – Docker Volumes & Networking

## 🎯Challenge Tasks

### 🔹Task 1: The Problem
1. Run a  MySQL container
<img width="1918" height="464" alt="Screenshot 2026-08-24 145729" src="https://github.com/user-attachments/assets/7ffc4bff-6d00-4964-b7c0-65bf7f453bf6" />

2. Create some data inside it (a table, a few rows — anything)
<img width="1919" height="830" alt="Screenshot 2026-08-24 150658" src="https://github.com/user-attachments/assets/4be67789-9204-4d45-b72d-afc533b04034" />
<img width="1918" height="837" alt="Screenshot 2026-08-24 150719" src="https://github.com/user-attachments/assets/a7ffbaca-0111-4ead-8a8a-690d0a413853" />

3. Stop and remove the container
<img width="1753" height="251" alt="Screenshot 2026-08-24 150835" src="https://github.com/user-attachments/assets/ed65088e-ed49-4723-bee6-55768a7412c6" />

4. Run a new one — is your data still there?
<img width="1448" height="728" alt="Screenshot 2026-08-24 150949" src="https://github.com/user-attachments/assets/4cee2ec6-f8f8-4852-943e-7987622824a1" />

## What happened and why----> Data is Still there- No, Data is lost when a container is removed because containers are ephemeral and do not persist data by default.

---

### 💾Task 2: Named Volumes
1. Create a named volume
<img width="1062" height="238" alt="Screenshot 2026-08-24 151053" src="https://github.com/user-attachments/assets/728b8822-9d71-434c-a0e7-1d4c0d76042d" />


2. Run the same database container, but this time **attach the volume** to it
<img width="1543" height="120" alt="Screenshot 2026-08-24 151629" src="https://github.com/user-attachments/assets/a8f9999b-5739-48b1-8f4b-20ee2488c3e8" />

3. Add some data, stop and remove the container
<img width="1091" height="642" alt="Screenshot 2026-08-24 151937" src="https://github.com/user-attachments/assets/5eca97ad-3e88-4f93-9462-c43314a93930" />
<img width="737" height="673" alt="Screenshot 2026-08-24 151945" src="https://github.com/user-attachments/assets/89b94182-d3b7-4808-b64a-3556a9c6fe41" />

4. Run a brand new container with the **same volume**
<img width="1360" height="170" alt="Screenshot 2026-08-24 152033" src="https://github.com/user-attachments/assets/10ca5801-567a-4dd9-9f5c-a22d8b71f320" />
<img width="1916" height="756" alt="Screenshot 2026-08-24 152215" src="https://github.com/user-attachments/assets/d8f3c6d7-f728-4277-9fed-8dcd908b3e3e" />
<img width="1156" height="415" alt="Screenshot 2026-08-24 152316" src="https://github.com/user-attachments/assets/10f0055c-c4fc-4eb2-9019-988f2ee7c8ed" />

5. Is the data still there?
- Yes, all previous data ,tables and rows are still there.

Verify: `docker volume ls`, `docker volume inspect`
<img width="992" height="190" alt="Screenshot 2026-08-24 152349" src="https://github.com/user-attachments/assets/831e7fc3-b1aa-4d32-9a18-1f47fb1a6f35" />
<img width="1000" height="313" alt="Screenshot 2026-08-24 152413" src="https://github.com/user-attachments/assets/79ea2a93-98f5-49f6-aef0-ff308ff4dd7c" />


---

### 📁Task 3: Bind Mounts
1. Create a folder on your host machine with an `index.html` file
<img width="1919" height="527" alt="Screenshot 2026-08-24 152703" src="https://github.com/user-attachments/assets/4be29fd6-6b33-4137-bd17-717b97e185db" />

2. Run an Nginx container and **bind mount** your folder to the Nginx web directory
3. Access the page in your browser
<img width="1285" height="350" alt="Screenshot 2026-08-24 152729" src="https://github.com/user-attachments/assets/b63199cc-9fa5-49f0-97f8-a5b01530c0c5" />

4. Edit the `index.html` on your host — refresh the browser
<img width="1686" height="303" alt="Screenshot 2026-08-24 153400" src="https://github.com/user-attachments/assets/e1edca44-b78f-42c6-98d4-b843353a3277" />

## What is the difference between a named volume and a bind mount?

**Volumes vs Bind Mounts**
**Volumes:**
- Managed by Docker.
- Stored in a part of the host filesystem which is managed by Docker.
- Preferred method for data persistence.

**Bind Mounts:**
- Maps a file or directory on the host to a file or directory in the container.
- More complex but provides flexibility to interact with the host system.
---

### 🌐Task 4: Docker Networking Basics
1. List all Docker networks on your machine
<img width="877" height="185" alt="Screenshot 2026-08-24 153443" src="https://github.com/user-attachments/assets/69a21af0-44bc-468d-84fd-c031c04b9167" />

2. Inspect the default `bridge` network
<img width="558" height="700" alt="Screenshot 2026-08-24 153545" src="https://github.com/user-attachments/assets/8c01d5bd-38fb-4da0-b29f-eff79c4a52ce" />

- `docker network inspect` is the command used to retrieve detailed configuration and status information about a specific Docker network.
- The `bridge network` is indeed the default network in Docker.

3. Run two containers on the default bridge — can they ping each other by **name**?
- NO

<img width="1788" height="352" alt="Screenshot 2026-08-24 153712" src="https://github.com/user-attachments/assets/d617f56c-5d51-424b-a3bd-46e89d9b57f6" />

4. Run two containers on the default bridge — can they ping each other by **IP**?
- Yes
<img width="1628" height="323" alt="Screenshot 2026-08-24 153851" src="https://github.com/user-attachments/assets/cbffddcd-3b9a-4ee3-bf51-38dfa1375aeb" />

---

### 🌐Task 5: Custom Networks
1. Create a custom bridge network called `my-app-net`
<img width="928" height="231" alt="Screenshot 2026-08-24 153945" src="https://github.com/user-attachments/assets/fe3d1eb0-1b39-4bf0-ac5c-91fcc00f5abb" />

2. Run two containers on `my-app-net`
- Conatiner Name-
- DB
- web

3. Can they ping each other by **name** now?
<img width="1225" height="281" alt="Screenshot 2026-08-24 154155" src="https://github.com/user-attachments/assets/d8c931bd-af35-4e56-af2c-974e366d6d3a" />


4. Write in your notes: Why does custom networking allow name-based communication but the default bridge doesn't?
- Default Docker `bridge network` `does not have built-in DNS`, so containers cannot resolve each other by name. They need IPs.
- `User-defined networks` have `embedded DNS`, so containers can communicate using their names.

---

### 🚀Task 6: Put It Together
1. Create a custom network
<img width="1919" height="430" alt="Screenshot 2026-08-24 154701" src="https://github.com/user-attachments/assets/04f593a6-ab0d-4076-8cb2-035379b0f43b" />


2. Run a **database container** (MySQL/Postgres) on that network with a volume for data
3. Run an **app container** (use any image) on the same network
4. Verify the app container can reach the database by container name
<img width="1225" height="281" alt="Screenshot 2026-08-24 154155" src="https://github.com/user-attachments/assets/d8c931bd-af35-4e56-af2c-974e366d6d3a" />

---

### 🧠 Key Learnings
- 💾 Docker Volumes → Provide persistent storage for containers.
- 📁 Bind Mounts → Allow host files/directories to be mounted into containers.
- 🌐 Docker Networks → Enable communication between containers.
- 🔍 Default Bridge → Containers can communicate using IP addresses, but name-based DNS resolution is limited.
- 🌐 Custom Networks → Provide automatic DNS-based container-name resolution.
- 🔗 Container Communication → Applications can communicate with databases using container names instead of hard-coded IP addresses.
- ♻️ Persistence → Volumes survive container removal unless the volume itself is deleted.

---

### 🎯 Conclusion

Day 32 was a great hands-on exercise to understand Docker storage and networking.
I learned how to:
- ✅ Persist database data using Docker volumes
- ✅ Use bind mounts for host-container file sharing
- ✅ Explore Docker's default networking
- ✅ Create custom bridge networks
- ✅ Enable container-to-container communication using names
- ✅ Connect an application container to a database container

---

Happy Learning!
**TrainWithShubham**
