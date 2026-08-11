# Day 09 – Linux User & Group Management
## 📌 Objective

Learn how to create and manage Linux users and groups, assign permissions, and configure shared directories for team collaboration.

## 🛠️ Users Created

- Created the following users with home directories:

    `sudo useradd -m tokyo` 

    `sudo useradd -m berlin` 

    `sudo useradd -m professor`

### Set passwords:

    `sudo passwd tokyo`
    
    `sudo passwd berlin`
    
    `sudo passwd professor`

<img width="1919" height="463" alt="Screenshot 2026-08-01 140148" src="https://github.com/user-attachments/assets/e84f24c5-50a9-492f-8082-af47ac686c5e" />

### Verify users:

 `cat /etc/passwd | grep -E "tokyo|berlin|professor"` 

### List home directories:
 `ls /home/`

<img width="1919" height="250" alt="Screenshot 2026-08-01 140421" src="https://github.com/user-attachments/assets/d3f22328-4ff1-4317-a601-a2d1559535da" />

## 👥 Groups Created

### Created the following groups:

    `sudo groupadd developers` 

    `sudo groupadd admins`

### Verify groups:

 `cat /etc/group | grep -E "developers|admins"`

<img width="1919" height="164" alt="Screenshot 2026-08-01 140549" src="https://github.com/user-attachments/assets/9b159fa9-6d29-41e8-b88f-07be6f27dc36" />
---

## 🔐 Group Assignments

### Assign users to groups:
- tokyo → developers
   `sudo usermod -aG developers tokyo`
  
- berlin → developers + admins
   `sudo usermod -aG developers,admins berlin`
  
- professor → admins
    `sudo usermod -aG admins professor`
  
### Verify memberships:

    `groups tokyo`

    `groups berlin`

    `groups professor`

<img width="1783" height="347" alt="Screenshot 2026-08-01 141018" src="https://github.com/user-attachments/assets/c5389c90-fcee-473c-a0e3-4b0b14927fe1" />

---

## 📂 Shared Development Directory

### Create project directory:

 `sudo mkdir /opt/dev-project`

### Assign group ownership:
 `sudo chgrp developers /opt/dev-project`

### Set permissions:

 `sudo chmod 775 /opt/dev-project`

### Verify:

   `ls -ld /opt/dev-project`

### Test access:

 `sudo -u tokyo touch /opt/dev-project/tokyo.txt`

 `sudo -u berlin touch /opt/dev-project/berlin.txt`

Verify files:

  `ls -ld /opt/dev-project/`

<img width="931" height="138" alt="Screenshot 2026-08-01 141354" src="https://github.com/user-attachments/assets/4fd0a083-dad5-4bc4-99e7-007e81d6b516" />

---

## 🤝 Team Workspace

### Create user:

 `sudo useradd -m nairobi`

 `sudo passwd nairobi`

### Create group:

 `sudo groupadd project-team`

### Add users:

 `sudo usermod -aG project-team nairobi`

 `sudo usermod -aG project-team tokyo`

### Create shared directory:

`sudo mkdir /opt/team-workspace`

### Assign group ownership:

 `sudo chgrp project-team /opt/team-workspace`

### Set permissions:

 `sudo chmod 775 /opt/team-workspace`

### Verify:

 `ls -ld /opt/team-workspace`

<img width="1244" height="421" alt="Screenshot 2026-08-01 142356" src="https://github.com/user-attachments/assets/9db5c40e-0923-4562-99a3-ae8c560f321f" />

### Test file creation:

 `sudo -u nairobi touch /opt/team-workspace/nairobi.txt`

 `ls -ld /opt/team-workspace/`

<img width="1376" height="296" alt="Screenshot 2026-08-01 142647" src="https://github.com/user-attachments/assets/29a85d9a-b727-4342-b240-d4e5bf36aa10" />

---

## ✅ Key Commands Used
useradd
passwd
groupadd
usermod
groups
mkdir
chgrp
chmod
touch
ls

## 📖 What I Learned
- Created Linux users with home directories.
- Set passwords and verified user accounts.
- Created groups and assigned users to one or more groups.
- Managed user memberships using usermod.
- Configured shared directories with group ownership.
- Applied Linux permissions using chmod 775.
- Tested collaborative access by creating files as different users.
- Understood how Linux user, group, and permission management supports secure team collaboration.
  
## 🚀 Skills Practiced
- Linux User Management
- Linux Group Management
- File Permissions
- Directory Ownership
- Access Control
- System Administration
- Linux Command Line
  
## ⭐ If you found this project helpful, feel free to star the repository!
