# Linux Commands Cheat Sheet
## #90DaysOfDevOps – Day 03
---

# 📁 File System Commands

| Command | Usage |
|---------|-------|
| `pwd` | Show the current working directory. |
| `ls` | List files and directories. |
| `ls -la` | Display detailed information including hidden files. |
| `cd <directory>` | Change the current directory. |
| `mkdir <name>` | Create a new directory. |
| `rmdir <name>` | Remove an empty directory. |
| `touch <file>` | Create a new empty file. |
| `cp source destination` | Copy files or directories. |
| `mv source destination` | Move or rename files/directories. |
| `rm <file>` | Delete a file. |
| `rm -r <directory>` | Delete a directory and its contents. |
| `cat <file>` | Display file contents. |
| `less <file>` | View large files page by page. |
| `head <file>` | Show the first 10 lines of a file. |
| `tail <file>` | Show the last 10 lines of a file. |
| `find . -name "<file>"` | Search for a file by name. |

---

# ⚙️ Process Management Commands

| Command | Usage |
|---------|-------|
| `ps` | Show running processes. |
| `ps -ef` | Display all running processes. |
| `top` | Monitor system processes in real time. |
| `kill <PID>` | Terminate a process using its Process ID. |
| `kill -9 <PID>` | Forcefully stop a process. |
| `jobs` | List background jobs. |
| `bg` | Resume a stopped job in the background. |
| `fg` | Bring a background job to the foreground. |

---

# 🌐 Networking Troubleshooting Commands

| Command | Usage |
|---------|-------|
| `ping google.com` | Check network connectivity. |
| `ip addr` | Display IP address information. |
| `curl https://example.com` | Test website or API response. |
| `dig google.com` | Perform DNS lookup. |

---

# 💾 System Information

| Command | Description |
|---------|-------------|
| `hostname` | Display the system hostname. |
| `uname -a` | Show kernel and OS details. |
| `uptime` | Display system uptime and load. |
| `free -h` | Show memory usage. |
| `lscpu` | Display CPU information. |
| `lsblk` | List block devices. |
| `whoami` | Display the current user. |
| `id` | Show user and group IDs. |

---

# 📌 Quick Tips

- Use `man <command>` to read the manual page.
- Use `command --help` for quick help.
- Press **Ctrl + C** to stop a running command.
- Press **Ctrl + R** to search command history.
- Use `history` to view previously executed commands.

---
