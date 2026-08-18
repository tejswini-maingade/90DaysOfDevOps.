# Day 28 – Revision Day: Everything from Day 1 to Day 27

> 📚 **Revision is not about learning something new. It is about making sure the concepts we already learned are strong enough to explain, troubleshoot, and use in real situations.**

## 🎯 Day 28 Goal

During the first 27 days, I covered DevOps & Cloud fundamentals, Linux administration, LVM, networking, shell scripting, cron automation, Git & GitHub, GitHub CLI, and GitHub profile branding.

Today I reviewed these topics, identified areas that need more practice, answered quick-fire questions, and documented what I learned.

---

# 1. 📊 My Learning Journey – Day 1 to Day 27

| Days | Topic | What I Learned |
|---|---|---|
| **Day 1** | DevOps & Cloud | DevOps culture, SDLC, automation, cloud fundamentals |
| **Days 2–7** | Linux Fundamentals | Architecture, commands, processes, systemd, filesystem, troubleshooting |
| **Day 8** | Cloud Server Setup | Docker, Nginx and web deployment |
| **Days 9–11** | Users & Permissions | Users, groups, passwords, `chmod`, `chown`, `chgrp` |
| **Day 12** | Revision | Reviewed Days 1–11 |
| **Day 13** | LVM | PV, VG, LV and storage management |
| **Days 14–15** | Networking | IP, DNS, ports, subnets and connectivity troubleshooting |
| **Days 16–18** | Shell Scripting | Variables, conditions, loops, arguments, functions and error handling |
| **Days 19–20** | Shell Projects | Log rotation, backups, cron and log analysis |
| **Day 21** | Shell Cheat Sheet | Created a personal scripting reference |
| **Days 22–25** | Git & GitHub | Branching, merge, rebase, stash, cherry-pick, reset, revert |
| **Day 26** | GitHub CLI | Managing GitHub repositories, issues, PRs and workflows from terminal |
| **Day 27** | GitHub Profile | README, repository organization and developer branding |

---

# 2. ✅ Self-Assessment Checklist

### Legend

- 🟢 **Can do confidently**
- 🟡 **Need to revisit**
- 🔴 **Haven't done yet**

## 🐧 Linux

| Skill | Status | Notes |
|---|:---:|---|
| Navigate filesystem, create/move/delete files | 🟢 | Comfortable with common commands |
| Manage processes | 🟢 | `ps`, `top`, `kill`, background/foreground |
| Work with systemd | 🟢 | `systemctl status/start/stop/enable` |
| Read/edit files with Vim/Nano | 🟢 | Used for configuration and scripts |
| Troubleshoot CPU, memory and disk | 🟢 | `top`, `free`, `df`, `du` |
| Explain Linux filesystem hierarchy | 🟢 | Understand `/etc`, `/var`, `/home`, `/tmp`, `/` |
| Create users and groups | 🟢 | Understand user/group administration |
| Set permissions with `chmod` | 🟢 | Numeric and symbolic permissions |
| Change ownership | 🟢 | `chown` and `chgrp` |
| Create/manage LVM | 🟡 | Understand PV → VG → LV; need continued practice |
| Check network connectivity | 🟢 | `ping`, `curl`, `ss`, `dig`, `nslookup` |
| Explain DNS, IP, subnets and ports | 🟡 | Fundamentals are clear; need more troubleshooting |

## 🐚 Shell Scripting

| Skill | Status | Notes |
|---|:---:|---|
| Variables, arguments and user input | 🟢 | Practiced through scripts |
| `if/elif/else` and `case` | 🟢 | Comfortable with conditions |
| `for`, `while`, `until` loops | 🟢 | Practiced loops |
| Functions and arguments | 🟢 | Practiced reusable functions |
| `grep`, `awk`, `sed`, `sort`, `uniq` | 🟡 | Need more complex examples |
| `set -euo pipefail` and `trap` | 🟡 | Understand purpose; need deeper practice |
| Schedule scripts with crontab | 🟢 | Practiced scheduled scripts |

## 🔀 Git & GitHub

| Skill | Status | Notes |
|---|:---:|---|
| Initialize, stage, commit and history | 🟢 | Comfortable |
| Create and switch branches | 🟢 | Practiced repeatedly |
| Push and pull from GitHub | 🟢 | Hands-on |
| Explain clone vs fork | 🟢 | Understand the difference |
| Merge branches | 🟢 | Practiced fast-forward and merge commits |
| Rebase and explain merge vs rebase | 🟡 | Concept clear; need more practice |
| `git stash` / `stash pop` | 🟢 | Practiced with conflicts |
| Cherry-pick commits | 🟡 | Practiced including conflict resolution |
| Squash merge vs regular merge | 🟡 | Understand concept; need practice |
| `git reset` soft/mixed/hard | 🟡 | Need repeated hands-on practice |
| `git revert` | 🟢 | Understand safe undoing of shared history |
| GitFlow / GitHub Flow / Trunk-Based | 🟡 | Need more real-world examples |
| GitHub CLI | 🟢 | Practiced repository, issue and PR workflows |

---

# 3. 🔎 My Three Main Weak Spots

## 1️⃣ Git Reset vs Revert / Rebase

- `git reset` moves the branch pointer and can rewrite local history.
- `git revert` creates a new commit that reverses an earlier commit.
- `git rebase` replays commits on top of another base.
- Rebase can create cleaner history but rewrites history.

### Practical rule

```text
Local/private work
      ↓
reset / rebase can be useful

Shared/public history
      ↓
prefer revert / merge
```

My goal is to become faster at deciding **when to reset, revert, merge, or rebase**.

---

## 2️⃣ Networking Troubleshooting

A useful troubleshooting flow is:

```text
Application
    ↓
Port
    ↓
IP connectivity
    ↓
Routing
    ↓
DNS
    ↓
Network interface
```

Useful commands:

```bash
ping <ip>
curl http://<ip>:<port>
ss -tulpn
ip addr
ip route
dig example.com
nslookup example.com
```

I want more practice with closed ports, DNS failures, firewall/security-group issues, wrong routes and services that are running but unreachable.

---

## 3️⃣ Shell Script Error Handling

A safer script can begin with:

```bash
set -euo pipefail
```

This helps with:

- failed commands
- unset variables
- failed commands inside pipelines

I want more practice with `trap`, exit codes, cleanup, error messages and safe variable handling.

> ⚠️ These options are useful safeguards, but they are not a replacement for thoughtful error handling.

---

# 4. ⚡ Quick-Fire Questions

## Q1. What does `chmod 755 script.sh` do?

```text
755 = rwx r-x r-x
```

- Owner → read, write, execute
- Group → read, execute
- Others → read, execute

---

## Q2. Process vs service?

A **process** is a running instance of a program.

A **service** is typically a long-running/background program managed by something such as `systemd`.

```bash
ps aux
systemctl status nginx
```

---

## Q3. How do you find which process is using port 8080?

```bash
sudo ss -ltnp | grep :8080
```

or:

```bash
sudo lsof -i :8080
```

---

## Q4. What does `set -euo pipefail` do?

- `-e` → exit when a command fails
- `-u` → treat unset variables as errors
- `pipefail` → a pipeline fails when a command inside it fails

```bash
set -euo pipefail
```

---

## Q5. `git reset --hard` vs `git revert`?

### Reset

```bash
git reset --hard HEAD~1
```

Moves the branch pointer and discards working-tree/index changes.

### Revert

```bash
git revert <commit>
```

Creates a new commit that reverses an earlier commit.

### Easy memory trick

```text
reset  → move/remove history
revert → add an undo commit
```

---

## Q6. Recommended branching strategy for a team of 5 shipping weekly?

I would generally recommend **GitHub Flow** for a small team with frequent delivery:

```text
main
  │
  ├── feature/login
  ├── feature/payment
  └── fix/api-timeout
```

Create a short-lived branch → make changes → push → Pull Request → review/CI → merge to `main`.

It is simpler than a heavy GitFlow model and works well with CI/CD.

---

## Q7. What does `git stash` do?

It temporarily saves uncommitted changes so the working directory becomes clean.

```bash
git stash
git stash pop
```

Useful when I need to switch context without creating an unfinished commit.

---

## Q8. How do you schedule a script every day at 3 AM?

```bash
crontab -e
```

Add:

```cron
0 3 * * * /path/to/script.sh
```

Cron format:

```text
minute hour day month weekday
  0     3    *    *      *
```

---

## Q9. `git fetch` vs `git pull`?

### Fetch

```bash
git fetch origin
```

Downloads remote changes without integrating them into the current branch.

### Pull

```bash
git pull
```

Usually performs fetch followed by merge/rebase according to configuration/options.

```text
fetch → download + inspect
pull  → download + integrate
```

---

## Q10. What is LVM?

**LVM (Logical Volume Manager)** provides a flexible layer for managing storage.

```text
Physical Disk
     ↓
Physical Volume (PV)
     ↓
Volume Group (VG)
     ↓
Logical Volume (LV)
     ↓
Filesystem
```

LVM makes storage management more flexible because logical volumes can often be resized and managed independently from the underlying physical disks.

---

# 5. 👩‍🏫 Teach It Back – Git Branching

Imagine five developers working on the same project.

If everyone changes the same code at the same time, their work can easily conflict.

Git branches provide separate workspaces for features and fixes.

For example:

```bash
git switch -c feature-login
```

I can now develop the login feature without directly changing `main`.

When finished:

```bash
git push -u origin feature-login
```

Then I create a Pull Request for review.

After review and successful CI checks, the branch can be merged into `main`.

```text
main
 │
 ├── feature-login
 │       └── changes
 │
 └── feature-payment
         └── changes
```

**Git branching allows developers to work independently while keeping the main codebase stable.**

---

# 6. 🛠️ Commands I Want to Keep Fresh

## Linux

```bash
pwd
ls -la
cd
mkdir
touch
cp
mv
rm
find
grep
cat
less
ps
top
kill
df -h
du -sh
free -h
systemctl status
journalctl
```

## Networking

```bash
ip addr
ip route
ping
curl
ss
dig
nslookup
```

## Shell

```bash
chmod +x script.sh
./script.sh
bash -x script.sh
crontab -e
```

## Git

```bash
git status
git log --oneline --graph
git branch
git switch
git add
git commit
git push
git pull
git fetch
git merge
git rebase
git stash
git stash pop
git cherry-pick
git reset
git revert
```

## GitHub CLI

```bash
gh auth status
gh repo list
gh repo view
gh repo clone
gh issue list
gh issue create
gh issue view
gh issue close
gh pr list
gh pr create
gh pr view
gh pr merge
gh run list
gh run view
```

---

# 7. 🧠 Key Lessons From Days 1–27

### 🐧 Linux
Linux is the foundation for many DevOps environments. Understanding processes, services, storage, permissions and troubleshooting is essential.

### 🌐 Networking
A DevOps engineer needs to understand how systems communicate through IP addresses, DNS, ports, routing and connectivity.

### 🐚 Shell Scripting
Automation starts with small scripts. Shell scripting can remove repetitive manual work and build operational automation.

### 🔀 Git
Git is more than `add`, `commit`, and `push`. Branching, merge, rebase, stash, cherry-pick, reset and revert are important for real workflows.

### 🐙 GitHub
GitHub adds collaboration around Git through repositories, Pull Requests, Issues, Actions and reviews.

### 🖥️ GitHub CLI
`gh` brings many GitHub operations directly into the terminal and makes them easier to automate.

### 👩‍💻 Developer Branding
Technical skills matter, but presenting projects clearly matters too. A clean GitHub profile makes my work easier to understand.

---

# 8. 📁 Submission Checklist

- [ ] `day-28-notes.md` created
- [ ] Days 1–27 are committed
- [ ] Days 1–27 are pushed to GitHub
- [ ] `git-commands.md` is updated
- [ ] Shell scripting cheat sheet is complete
- [ ] Repository descriptions are meaningful
- [ ] Important repositories are pinned
- [ ] GitHub profile README is updated
- [ ] All changes are pushed to my fork

---

# 9. 🎯 My Next Focus

The biggest lesson from this revision is:

> **Knowing a command is different from being able to troubleshoot with it.**

My next focus areas are:

1. 🔀 Become more confident with advanced Git workflows.
2. 🌐 Practice networking troubleshooting scenarios.
3. 🐚 Write safer, production-oriented shell scripts.
4. ☁️ Continue building hands-on AWS and DevOps projects.
5. 🤖 Connect these fundamentals with CI/CD and automation.

---

# 📝 Final Reflection

The first 27 days helped me build a strong foundation across Linux, networking, shell scripting, Git, GitHub and DevOps fundamentals.

This revision showed me that some topics need repeated hands-on practice rather than simply reading commands.

The most important takeaway is:

> **Learning DevOps is not about memorizing commands. It is about understanding why a tool is used, knowing how to troubleshoot problems, and being able to automate repetitive work.**

I'm continuing the journey one day at a time — **learning, practicing, troubleshooting, documenting, and improving.** 🚀

---

<div align="center">

### 🚀 Day 28 Complete

**Learn → Practice → Break → Troubleshoot → Understand → Improve**

`#90DaysOfDevOps` • `#DevOpsKaJosh` • `#TrainWithShubham`

</div>
