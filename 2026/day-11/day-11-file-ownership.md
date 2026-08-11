# 🚀Day-11: File Ownership (chown & chgrp)

## 👤 Understanding Ownership
- Run `ls -l` in your home directory

  <img width="701" height="187" alt="Screenshot 2026-08-01 152658" src="https://github.com/user-attachments/assets/04303cc8-c49c-4e13-9d4c-5e7762953769" />


    `-rw-r--r-- 1 owner group size date filename`

    -   Owner → Individual user with direct control.

    -   Group → Multiple users who may share access.

## 📁 Files & Directories Created
- Basic `chown` Operations

    `touch devops-file.txt`

    `ls -l devops-file.txt`

 <img width="730" height="101" alt="Screenshot 2026-08-01 152643" src="https://github.com/user-attachments/assets/9fa9171d-b69b-41bb-a370-2a0a10b4b9bd" />

    `sudo chown tokyo devops-file.txt`

    `ls -l devops-file.txt`

<img width="724" height="114" alt="Screenshot 2026-08-01 152740" src="https://github.com/user-attachments/assets/bf859510-8709-4235-a030-ad2d569fd4d6" />


    `sudo chown berlin devops-file.txt`

    `ls -l devops-file.txt`

  <img width="717" height="117" alt="Screenshot 2026-08-01 152816" src="https://github.com/user-attachments/assets/019cfabe-71f0-4044-b817-7703630274f8" />


- Basic `chgrp` Operations

    `touch team-notes.txt`

    `ls -l team-notes.txt`

  <img width="709" height="101" alt="Screenshot 2026-08-01 152846" src="https://github.com/user-attachments/assets/153d10a9-f588-4e14-8434-200525943ed7" />

    `sudo groupadd heist-team`

    `sudo chgrp heist-team team-notes.txt`

    `ls -l team-notes.txt`

  <img width="786" height="128" alt="Screenshot 2026-08-01 153349" src="https://github.com/user-attachments/assets/7f8e6c70-c399-4d74-ac50-2df962b0c805" />


##  👥Ownership Changes
- Combined Owner & Group Change

    `touch project-config.yaml`

    `sudo chown professor:heist-team project-config.yaml`

    `mkdir app-logs`

    `sudo chown berlin:heist-team app-logs`

    `ls -l`
<img width="1919" height="407" alt="Screenshot 2026-08-01 153512" src="https://github.com/user-attachments/assets/394fe6e7-743c-48dc-b461-b3c2fe8b977f" />


- 📂 Recursive Ownership
    
    `mkdir -p heist-project/vault`
    
    `mkdir -p heist-project/plans`

    `touch heist-project/vault/gold.txt`

    `touch heist-project/plans/strategy.conf`

    `sudo groupadd planners`

    `sudo chown -R professor:planners heist-project/`

    `ls -lR heist-project/`

<img width="1919" height="518" alt="Screenshot 2026-08-01 153644" src="https://github.com/user-attachments/assets/6b4207cf-86a0-4343-a3f1-0008bb0e1864" />


- 🎯 Practice Challenge

    -  👤 Create users
        
        `sudo useradd tokyo`

        `sudo useradd berlin`

        `sudo useradd nairobi`

    -   👥 Create groups
    
        `sudo groupadd vault-team`

        `sudo groupadd tech-team`

    -  📂 Create directory

        `mkdir bank-heist`
    
    - 📄 Create 3 files inside

    `touch bank-heist/access-codes.txt`

    `touch bank-heist/blueprints.pdf`

    `touch bank-heist/escape-plan.txt`

    - 🔐 Set different ownership

    `sudo chown tokyo:vault-team bank-heist/access-codes.txt`

    `sudo chown berlin:tech-team bank-heist/blueprints.pdf`

    `sudo chown nairobi:vault-team bank-heist/escape-plan.txt`

    - ✅ Verify

    `ls -l bank-heist/`
  
<img width="1919" height="435" alt="Screenshot 2026-08-01 153938" src="https://github.com/user-attachments/assets/d8898cfd-9b40-4f3a-9921-95dac86653f4" />


## 💻 Commands Used
1. View ownership

    `ls -l filename`

2. Change owner only

    `sudo chown newowner filename`

3. Change group only

    `sudo chgrp newgroup filename`

4. Change both owner and group

    `sudo chown owner:group filename`

5. Recursive change (directories)

    `sudo chown -R owner:group directory/`

6. Change only group with chown

    `sudo chown :groupname filename`


## 💡What I Learned
👤 1. Dual Ownership Model  
    Every file in Linux has two ownership attributes:
    - Owner (user): The individual account that created or owns the file.
    - Group: A collection of users who may share access to the file. This ensures collaborative work without giving full control to everyone. 

🔒 2. Ownership Controls Access & Security  
    File ownership, combined with permissions, determines who can read, write, or execute a file. This is a cornerstone of Linux’s multi-user security model, preventing unauthorized access or modification. 

⚙️ 3. Ownership Can Be Changed with Commands  
    Administrators can reassign ownership using:
    - chown → change file owner (and optionally group).
    - chgrp → change group ownership.
    - Recursive flags (-R) allow applying changes across entire directories. These commands are essential for managing shared projects and system security.
