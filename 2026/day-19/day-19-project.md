# 🚀 Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

> 🛠️ **90 Days of DevOps Challenge**
> 📅 **Day 19 | Shell Scripting – Automation & Maintenance**

Today I worked on practical **Shell Scripting automation** for log management, server backups, and scheduled maintenance using **Crontab**.

---

## 📋 Task 1: Log Rotation Script

### 🎯 Objective

Create `log_rotate.sh` that:

* 📂 Takes a log directory as an argument
  Example: `/var/log/myapp`
* 🗜️ Compresses `.log` files older than **7 days** using `gzip`
* 🗑️ Deletes `.gz` files older than **30 days**
* 📊 Prints the number of files **compressed and deleted**
* ❌ Exits with an error if the directory doesn't exist
  
<img width="1919" height="628" alt="Screenshot 2026-08-11 121703" src="https://github.com/user-attachments/assets/a449cb54-507e-4fd9-9434-5e95b91e4a31" />


---

## 💾 Task 2: Server Backup Script

### 🎯 Objective

Create `backup.sh` that:

* 📁 Takes a **source directory** and **backup destination** as arguments
* 🕐 Creates a timestamped `.tar.gz` archive
* 📦 Example: `backup-2026-02-08.tar.gz`
* ✅ Verifies that the archive was created successfully
* 📏 Prints the archive name and size
* 🧹 Deletes backups older than **14 days**
* ❌ Exits if the source directory doesn't exist

<img width="1297" height="392" alt="Screenshot 2026-08-11 122159" src="https://github.com/user-attachments/assets/9ed6e701-c7dd-42f5-870e-f89713f25191" />


---

## ⏰ Task 3: Crontab

### 🔍 Check Existing Cron Jobs

```bash
crontab -l
```

This command displays the cron jobs currently scheduled for the user.

### 🧩 Cron Syntax

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── 📅 Day of week (0-7)
│ │ │ └──── 📆 Month (1-12)
│ │ └────── 📅 Day of month (1-31)
│ └──────── ⏰ Hour (0-23)
└────────── ⏱️ Minute (0-59)
```

### 📌 Cron Examples

| ⏰ Schedule    | 📝 Purpose                                   |
| ------------- | -------------------------------------------- |
| `0 2 * * *`   | 🔄 Run `log_rotate.sh` every day at 2 AM     |
| `0 3 * * 7`   | 💾 Run `backup.sh` every Sunday at 3 AM      |
| `*/5 * * * *` | ❤️ Run health check every 5 minutes          |
| `0 1 * * *`   | 🛠️ Run maintenance script every day at 1 AM |


<img width="1885" height="586" alt="Screenshot 2026-08-11 125604" src="https://github.com/user-attachments/assets/51e7ec27-3369-4b96-bf54-3d08555bcd66" />

<img width="1045" height="471" alt="Screenshot 2026-08-11 130154" src="https://github.com/user-attachments/assets/770cb229-1831-4887-8cc4-372e2714f983" />

---

## 🔧 Task 4: Combine – Scheduled Maintenance Script

Create `maintenance.sh` that:

* 🔄 Calls the **log rotation** function
* 💾 Calls the **backup** function
* 📝 Logs all output to `/var/log/maintenance.log`
* 🕐 Adds timestamps to maintenance logs
* ⏰ Runs automatically every day at **1 AM**

### 📅 Cron Entry

```bash
0 1 * * * /path/to/maintenance.sh
```

<img width="1597" height="498" alt="Screenshot 2026-08-11 130701" src="https://github.com/user-attachments/assets/c36539d1-b423-4bc7-ac0c-8177dbb2e2ad" />


---

## 📚 What I Learned

### 🐧 Shell Scripting

* 🔎 Using `find` with `-mtime` to filter files based on age
* 🗜️ Compressing files using `gzip`
* 📦 Creating `.tar.gz` backups using `tar`
* 🕐 Creating timestamped backup archives

### ⏰ Cron Automation

* 🧩 Understanding Cron syntax
* 📅 Scheduling recurring tasks
* ⚙️ Automating server maintenance

### 📝 Logging & Monitoring

* 📄 Writing script output to log files
* 🕐 Adding timestamps to logs
* 🚨 Handling script errors and exit conditions

---

## 💡 Key Takeaway

> 🚀 **Automation reduces manual work and makes server maintenance more reliable, repeatable, and scalable.**

### 🔥 Skills Practiced

`Shell Scripting` • `Linux` • `find` • `gzip` • `tar` • `Crontab` • `Automation` • `Backup` • `Log Management`

---
