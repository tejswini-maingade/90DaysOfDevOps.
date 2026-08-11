# Linux Architecture Notes

## Core Components of Linux

* **Hardware**: Physical components such as CPU, RAM, storage, and input/output devices.
* **Kernel**: Heart of linux or Core of Linux that manages hardware resources, memory, processes and system resources.
* **User Space**: Area where users and applications run.
* **Shell**: Command-line interface used to communicate with the kernel.
* **systemd**: The first process started during boot (PID 1).

---

# Processes in Linux

- A process is a program that is currently running.
- Every process has a unique PID (Process ID) to identify it.
- A parent process can start another process called a child process.
- The kernel decides which process gets to use the CPU and when.
- A process can run: Foreground – runs on your screen and you interact with it. Background – runs behind the scenes without interrupting your work.

---

## Process States

| State | Meaning |
|--------|---------|
| R | Running (using CPU) |
| S | Sleeping (waiting for an event) |
| D |  waiting for disk I/O |
| T | Stopped |
| Z | Zombie (finished but waiting for parent process) |

---

# Understanding systemd

systemd is the init system used in most modern Linux distributions.

Functions:
- Starts services during boot
- Manages services
- Handles service failures
- Controls boot order
- Maintains system state

Useful Commands:

```bash
systemctl status sshd
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl enable nginx
systemctl disable nginx

```
---

# 5 Commands Used Daily

* **top** : Monitor system resources in real time.
* **ps -ef** : Show all running process.
* **systemctl** : Manage services.
* **df -h** : Check disk usage.
* **free -h** : Check memory usage.

---

# Easy Interview Points

✔ Hardware = Physical devices

✔ Kernel = Brain of Linux

✔ Shell = Command interface

✔ User Space = Runs applications

✔ systemd = Starts and manages services

✔ Process = Running program

✔ Every process has a unique PID

✔ systemd always runs with PID 1

