# Day 07 – Linux File System Hierarchy & Scenario-Based Practice

# Part 1: Linux File System Hierarchy

| Directory | Purpose | Example | 
|-----------|---------|---------|
| `/` | Starting point of the Linux file system. Everything begins here. | `home`, `etc`, `var` |
| `/home` | Stores home directories of normal users. | `suraj`, `user1` | 
| `/root` | Home directory of the root (administrator) user. | `.bashrc`, `.ssh` | 
| `/etc` | Stores system configuration files. | `hostname`, `passwd`, `hosts` |
| `/var/log` | Stores system and application log files. | `messages`, `secure`, `auth.log` | 
| `/tmp` | Stores temporary files. Files are usually removed after reboot. | Temporary files | 
| `/bin` | Contains essential Linux commands. | `ls`, `cp`, `mv`, `cat` | 
| `/usr/bin` | Contains most user commands and installed applications. | `vim`, `python3`, `mkdir` | 
| `/opt` | Stores optional or third-party software. | Google Chrome, Custom Apps |

---

# Hands-on Practice

- Use the command `du -sh /var/log/* 2>/dev/null | sort -h | tail -5` to find 5 largest log file
-  checkthe configuration file `/etc/hostname ` to get the hostname
-  lsited all the file and directory in the home directory ` ls -la `
  
  <img width="1912" height="824" alt="Screenshot 2026-07-30 232715" src="https://github.com/user-attachments/assets/6da903e9-daa2-467f-ba42-d1a65aa1c055" />


# Part 2: Scenario-Based Practice

## Scenario 1 – Service Not Starting

### Step 1

```bash
systemctl status myapp
```

**Why:** Check whether the service is running, stopped, or failed.

### Step 2

```bash
journalctl -u myapp -n 50
```

**Why:** View the last 50 log messages.

### Step 3

```bash
systemctl is-enabled myapp
```

**Why:** Check if the service starts automatically after reboot.

### Step 4

```bash
systemctl restart myapp
```

**Why:** Restart the service after fixing the issue.

**What I learned**
- Always check service status first.
- Then check logs.
- Finally verify if the service is enabled.

---

## Scenario 2 – High CPU Usage

### Step 1

```bash
top
```

**Why:** Shows live CPU usage.

### Step 2

```bash
ps aux --sort=-%cpu | head -10
```

**Why:** Displays the processes using the most CPU.

### Step 3

```bash
pgrep <process_name>
```

**Why:** Finds the Process ID (PID).

### Step 4

```bash
kill -15 PID
```

**Why:** Stops the process if required.

**What I learned**
- Find the process with high CPU usage before taking action.

---

## Scenario 3 – Finding Service Logs

### Step 1

```bash
systemctl status docker
```

**Why:** Check Docker service status.

### Step 2

```bash
journalctl -u docker -n 50
```

**Why:** View the last 50 log entries.

### Step 3

```bash
journalctl -u docker -f
```

**Why:** Watch logs in real time.

**What I learned**
- `journalctl` is used to view logs of systemd services.

---

## Scenario 4 – File Permission Issue

### Step 1

```bash
ls -l /home/user/backup.sh
```

**Why:** Check current file permissions.

### Step 2

```bash
chmod +x /home/user/backup.sh
```

**Why:** Give execute permission.

### Step 3

```bash
ls -l /home/user/backup.sh
```

**Why:** Verify execute permission is added.

### Step 4

```bash
./backup.sh
```

**Why:** Run the script.

**What I learned**
- Always check file permissions before running a script.

---

# Summary

- Learned the Linux File System Hierarchy.
- Learned where logs, configuration files, binaries, and user files are stored.
- Practiced troubleshooting service issues, CPU usage, logs, and file permissions.
- Improved Linux skills for DevOps and real-world troubleshooting.

**✅ Day 07 Completed**
