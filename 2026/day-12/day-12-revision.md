# 🚀 Day 12 – Breather & Revision (Days 01–11)

## 🎯 Goal

Take a short break from learning new concepts and reinforce the Linux fundamentals covered in **Days 01–11**. The focus today is on revision, retention, and building confidence through quick hands-on practice.

---

# 📚 Revision Checklist

## 🧠 Mindset & Learning Plan

* ✅ Reviewed my Day 01 learning roadmap.
* ✅ My goal of becoming a DevOps Engineer remains the same.
* ✅ Will continue focusing on Linux, AWS, Docker, Kubernetes, CI/CD, and Infrastructure Automation.

---

## ⚙️ Processes & Services

### Commands Practiced

```bash
ps -ef
systemctl status sshd
journalctl -u sshd --no-pager
```

### Observations

* Verified currently running processes.
* Checked that the SSH service is active.
* Reviewed recent SSH service logs.

---

## 📂 File Operations Practice

### Commands Practiced

```bash
echo "Revision Day" >> notes.txt
chmod 755 script.sh
mkdir revision-folder
cp notes.txt revision-folder/
ls -l
```

### What I Verified

* Appended text successfully.
* Changed file permissions.
* Created a new directory.
* Copied files successfully.
* Verified permissions and ownership.

---

## 📋 Linux Cheat Sheet Refresh

### Top 5 Commands I Would Use During an Incident

| Command                      | Purpose                              |
| ---------------------------- | ------------------------------------ |
| `ls -l`                      | Check file permissions and ownership |
| `ps -ef`                     | View running processes               |
| `systemctl status <service>` | Check service health                 |
| `journalctl -u <service>`    | Review service logs                  |
| `chmod`                      | Modify file permissions              |

---

## 👥 User & Group Practice

### Scenario

Created a test user and verified the account.

```bash
sudo useradd revisionuser
id revisionuser
```

Verified ownership:

```bash
touch testfile.txt
ls -l testfile.txt
```

---

# ✅ Mini Self-Check

### ❓ Which 3 commands save you the most time right now, and why?

* **ls -l** → Quickly checks permissions and ownership.
* **systemctl status** → Instantly verifies service health.
* **journalctl -u** → Helps troubleshoot service-related issues.

---

### ❓ How do you check if a service is healthy?

Commands I use first:

```bash
systemctl status sshd
ps -ef | grep sshd
journalctl -u sshd --no-pager
```

---

### ❓ How do you safely change ownership and permissions?

Example:

```bash
sudo chown suraj:developers project.txt
chmod 640 project.txt
```

This changes the owner and group while ensuring only the owner has write access.

---

### ❓ What will you focus on improving in the next 3 days?

* Strengthen Linux administration skills.
* Practice more troubleshooting scenarios.
* Continue learning networking and shell scripting fundamentals.

---

# 💡 Key Takeaways

* Linux commands become easier with regular practice.
* Understanding permissions and ownership is essential for system security.
* Process and service troubleshooting are core DevOps skills.
* Consistent revision improves long-term retention.
* Hands-on practice is the fastest way to build confidence.

---

# 🚀 Progress Summary

✅ Revised Linux fundamentals (Days 01–11)

✅ Practiced process and service management

✅ Reviewed file operations and permissions

✅ Reinforced user and group management

✅ Ready to continue the #90DaysOfDevOps journey!

---


