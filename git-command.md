# 🚀 Git Commands Cheat Sheet

> 📚 **Complete Git reference for DevOps practice**
>
> This cheat sheet contains commonly used Git commands from **basic Git setup to advanced Git workflows**.
>
> 🔄 Keep updating this file as you learn new Git commands.

---

# 🧭 Git Workflow at a Glance

```text
📂 Working Directory
        │
        │ git add
        ▼
📥 Staging Area
        │
        │ git commit
        ▼
🗃️ Local Repository
        │
        │ git push
        ▼
🌐 Remote Repository (GitHub)
```

### ⭐ Basic Workflow

```text
✏️ Modify → 📥 Add → 💾 Commit → 🚀 Push
```

---

# ⚙️ 1. Git Installation & Setup

## 🔍 Check Git Version

```bash
git --version
```

👉 Shows the installed Git version.

---

## 👤 Configure Username

```bash
git config --global user.name "Your Name"
```

👉 Sets the username used for Git commits.

---

## 📧 Configure Email

```bash
git config --global user.email "your-email@example.com"
```

👉 Sets the email associated with your Git commits.

---

## 🔎 View Configuration

```bash
git config --list
```

or:

```bash
git config --global --list
```

👉 Displays Git configuration values.

---

## 📖 View Help

```bash
git help
```

```bash
git help <command>
```

Example:

```bash
git help commit
```

or:

```bash
git commit --help
```

👉 Opens documentation for a Git command.

---

# 📁 2. Create & Initialize Repository

## 📂 Create a Directory

```bash
mkdir project-name
```

👉 Creates a new directory.

---

## 📌 Enter Directory

```bash
cd project-name
```

👉 Moves into the project directory.

---

## 🚀 Initialize Git Repository

```bash
git init
```

👉 Converts the current directory into a Git repository.

Creates:

```text
📁 .git/
```

---

## 🔍 Check Repository Status

```bash
git status
```

👉 Shows:

* 🆕 Untracked files
* ✏️ Modified files
* 📥 Staged files
* 🌿 Current branch

⭐ **Remember:** `git status` is one of the most useful Git commands.

---

# 📥 3. Staging Changes

## ➕ Stage One File

```bash
git add filename
```

Example:

```bash
git add README.md
```

👉 Adds one file to the staging area.

---

## ➕ Stage Multiple Files

```bash
git add file1 file2
```

👉 Stages selected files.

---

## 📦 Stage Everything

```bash
git add .
```

👉 Stages all changes in the current directory.

---

## ❌ Unstage a File

```bash
git restore --staged filename
```

👉 Removes a file from the staging area without deleting the file.

---

# 💾 4. Commit Changes

## 💾 Create Commit

```bash
git commit -m "Commit message"
```

Example:

```bash
git commit -m "Add Git commands"
```

👉 Saves staged changes as a permanent snapshot.

---

## 📝 Commit All Tracked Changes

```bash
git commit -am "Update application"
```

👉 Stages and commits modified/deleted **tracked** files.

⚠️ It does not include new untracked files.

---

## ✏️ Modify Last Commit

```bash
git commit --amend
```

👉 Changes the most recent commit.

---

# 🔍 5. View Changes

## 📊 View Repository Status

```bash
git status
```

---

## 🔎 View Unstaged Changes

```bash
git diff
```

👉 Shows changes that haven't been staged.

---

## 📥 View Staged Changes

```bash
git diff --staged
```

👉 Shows changes already added to staging.

---

## 📜 View Commit History

```bash
git log
```

👉 Shows detailed commit history.

---

## ⚡ Compact Commit History

```bash
git log --oneline
```

Example:

```text
a12bc34 Update README
b45cd67 Add Dockerfile
c78de90 Initial commit
```

---

## 🌳 Beautiful Commit Tree

```bash
git log --oneline --graph --decorate --all
```

👉 Shows branches and commits as a visual tree.

---

## 🔍 Show a Specific Commit

```bash
git show <commit-id>
```

Example:

```bash
git show a12bc34
```

👉 Shows details and changes introduced by a commit.

---

# 🌿 6. Branches

## 🌱 List Branches

```bash
git branch
```

👉 Shows local branches.

---

## 🌱 Create Branch

```bash
git branch feature-login
```

👉 Creates a new branch.

---

## 🔄 Switch Branch

```bash
git switch feature-login
```

---

## 🚀 Create and Switch

```bash
git switch -c feature-login
```

👉 Creates a new branch and immediately switches to it.

---

## 🔀 Merge Branch

First switch to the target branch:

```bash
git switch main
```

Then:

```bash
git merge feature-login
```

👉 Merges `feature-login` into `main`.

---

## 🗑️ Delete Local Branch

```bash
git branch -d feature-login
```

👉 Deletes a merged local branch.

Force delete:

```bash
git branch -D feature-login
```

⚠️ Use `-D` carefully.

---

# 🌐 7. Remote Repository / GitHub

## 🔗 Add Remote

```bash
git remote add origin https://github.com/USERNAME/REPOSITORY.git
```

👉 Connects the local repository to GitHub.

---

## 🔍 View Remote

```bash
git remote -v
```

👉 Shows remote repository URLs.

---

## ✏️ Change Remote URL

```bash
git remote set-url origin https://github.com/USERNAME/REPOSITORY.git
```

👉 Changes the URL of an existing remote.

---

## 📤 Push to GitHub

```bash
git push origin main
```

👉 Uploads local commits to the remote `main` branch.

---

## 🚀 First Push

```bash
git push -u origin main
```

👉 Pushes the branch and establishes an upstream relationship.

After that, you can usually use:

```bash
git push
```

---

## 📥 Download Remote Changes

```bash
git fetch
```

👉 Downloads remote changes without merging them.

---

## 📥 Pull Changes

```bash
git pull
```

👉 Fetches remote changes and merges them into the current branch.

---

## 📥 Clone Repository

```bash
git clone https://github.com/USERNAME/REPOSITORY.git
```

👉 Creates a local copy of a remote repository.

---

# 🔄 8. Fetch vs Pull

### 📥 `git fetch`

```bash
git fetch
```

Downloads changes but does **not** modify your current working branch.

### 📥 `git pull`

```bash
git pull
```

Fetches changes and integrates them into your current branch.

### 🧠 Easy Memory Trick

```text
fetch → 👀 Download & inspect
pull  → 📥 Download + integrate
```

---

# ↩️ 9. Undo Changes

## ❌ Discard Working Directory Changes

```bash
git restore filename
```

👉 Restores the file to the last committed/staged state.

⚠️ Uncommitted changes can be lost.

---

## ↩️ Unstage File

```bash
git restore --staged filename
```

👉 Removes the file from staging.

---

## ↩️ Undo Last Commit but Keep Changes

```bash
git reset --soft HEAD~1
```

👉 Removes the last commit but keeps changes staged.

---

## ↩️ Undo Last Commit and Unstage Changes

```bash
git reset --mixed HEAD~1
```

👉 Removes the last commit and leaves changes in the working directory.

---

## ⚠️ Hard Reset

```bash
git reset --hard HEAD~1
```

👉 Removes the last commit and discards associated changes.

⚠️ **Dangerous:** Changes may be permanently lost.

---

# 🔁 10. Revert Commit

```bash
git revert <commit-id>
```

Example:

```bash
git revert a12bc34
```

👉 Creates a new commit that reverses the changes introduced by another commit.

### 🧠 Reset vs Revert

```text
reset  → 🗑️ Move/remove history
revert → ↩️ Create a new commit that undoes changes
```

⭐ In shared branches, `git revert` is generally safer than rewriting published history.

---

# 🍒 11. Git Cherry-Pick

```bash
git cherry-pick <commit-id>
```

Example:

```bash
git cherry-pick a12bc34
```

👉 Applies the changes from a specific commit to the current branch.

Useful when you need **one particular change** from another branch.

---

# 📦 12. Git Stash

## 📥 Save Temporary Changes

```bash
git stash
```

👉 Temporarily stores uncommitted changes.

---

## 📋 List Stashes

```bash
git stash list
```

👉 Shows saved stashes.

---

## ♻️ Apply Stash

```bash
git stash apply
```

👉 Applies the latest stash without deleting it.

---

## 📤 Pop Stash

```bash
git stash pop
```

👉 Applies the latest stash and removes it from the stash list.

---

## 🗑️ Delete Stash

```bash
git stash drop
```

👉 Deletes the latest stash.

---

## 🗑️ Delete All Stashes

```bash
git stash clear
```

⚠️ Deletes all stashed changes.

---

# 🏷️ 13. Git Tags

## 🏷️ Create Tag

```bash
git tag v1.0.0
```

👉 Creates a lightweight tag.

---

## 📋 List Tags

```bash
git tag
```

---

## 📤 Push Tag

```bash
git push origin v1.0.0
```

---

## 📤 Push All Tags

```bash
git push origin --tags
```

---

# 🧹 14. Remove Files

## 🗑️ Remove File from Git and Disk

```bash
git rm filename
```

👉 Removes the file and stages the deletion.

---

## 🔗 Remove File from Git but Keep Locally

```bash
git rm --cached filename
```

👉 Removes the file from Git tracking but keeps it on your machine.

---

# 🙈 15. `.gitignore`

Create:

```text
.gitignore
```

Example:

```text
*.log
.env
node_modules/
__pycache__/
*.tmp
```

👉 `.gitignore` tells Git which files should not be tracked.

### Check ignored files

```bash
git status --ignored
```

---

# 🔎 16. Search Git History

## 🔍 Search Commit Messages

```bash
git log --grep="bug"
```

👉 Finds commits containing `bug` in their message.

---

## 🔍 Search Changes

```bash
git log -S "function_name"
```

👉 Finds commits where the specified text was added or removed.

---

# 👤 17. Git Identity

## 🔍 Check Username

```bash
git config user.name
```

---

## 🔍 Check Email

```bash
git config user.email
```

---

## 🗑️ Remove Global Configuration

```bash
git config --global --unset user.name
```

```bash
git config --global --unset user.email
```

---

# 📌 18. HEAD

`HEAD` points to the commit or branch you are currently working on.

Check:

```bash
git status
```

You may see:

```text
On branch main
```

### View HEAD

```bash
git rev-parse HEAD
```

👉 Shows the commit ID currently referenced by `HEAD`.

---

# 🔢 19. HEAD~ and HEAD^

### Previous Commit

```bash
HEAD~1
```

means:

```text
HEAD → Previous Commit
```

### Example

```bash
git show HEAD~1
```

👉 Shows the previous commit.

---

# 🔀 20. Merge Conflicts

Sometimes Git cannot automatically merge changes.

You may see:

```text
<<<<<<< HEAD
Your changes
=======
Other branch changes
>>>>>>> feature
```

### Conflict Resolution Workflow

```text
⚠️ Conflict
    ↓
✏️ Edit File
    ↓
📥 git add
    ↓
💾 git commit
```

Commands:

```bash
git status

# Edit conflicted file

git add <file>

git commit -m "Resolve merge conflict"
```

---

# 🧬 21. Rebase

```bash
git rebase main
```

👉 Replays your branch commits on top of another branch.

### Basic Idea

```text
Before:

A---B---C  main
     \
      D---E  feature


After rebase:

A---B---C---D'---E'  feature
```

⚠️ Avoid rebasing shared/public history unless you understand the consequences.

---

# 🧹 22. Clean Untracked Files

Preview:

```bash
git clean -n
```

👉 Shows what would be removed.

Actually remove:

```bash
git clean -f
```

⚠️ This permanently deletes untracked files.

---

# 🗃️ 23. Git Object Database

Git stores objects inside:

```text
.git/objects/
```

Main object types:

```text
📦 Blob    → File contents
🌳 Tree    → Directory structure
💾 Commit  → Snapshot + metadata
🏷️ Tag     → Named reference
```

---

# 🔍 24. Inspect Repository

## 📊 Repository Information

```bash
git status
```

## 🔗 Remote Information

```bash
git remote -v
```

## 🌿 Branch Information

```bash
git branch -a
```

## 📜 History

```bash
git log --oneline --graph --decorate --all
```

---

# 🧠 25. Most Important Git Commands

If you are a beginner, remember these first:

| Symbol | Command      | Purpose                           |
| ------ | ------------ | --------------------------------- |
| ⚙️     | `git config` | Configure Git                     |
| 🚀     | `git init`   | Create repository                 |
| 🔍     | `git status` | Check repository state            |
| 📥     | `git add`    | Stage changes                     |
| 💾     | `git commit` | Save changes                      |
| 📜     | `git log`    | View history                      |
| 🌿     | `git branch` | Manage branches                   |
| 🔀     | `git merge`  | Merge branches                    |
| 🌐     | `git remote` | Manage remote                     |
| 📤     | `git push`   | Upload commits                    |
| 📥     | `git pull`   | Download + integrate              |
| 📦     | `git clone`  | Copy remote repository            |
| ↩️     | `git revert` | Undo with a new commit            |
| 🔄     | `git reset`  | Move HEAD / rewrite local history |
| 🧳     | `git stash`  | Temporarily save changes          |

---

# 🚀 26. Real-World DevOps Git Workflow

A common workflow is:

```bash
# 1️⃣ Clone repository
git clone <repository-url>

# 2️⃣ Enter project
cd project

# 3️⃣ Check status
git status

# 4️⃣ Create feature branch
git switch -c feature/my-change

# 5️⃣ Make changes
vim application.yml

# 6️⃣ Review changes
git diff

# 7️⃣ Stage changes
git add .

# 8️⃣ Commit
git commit -m "Update application configuration"

# 9️⃣ Push branch
git push -u origin feature/my-change

# 🔟 Create Pull Request on GitHub
```

### 🔄 Visual Workflow

```text
🌐 GitHub
   │
   │ git clone
   ▼
📂 Local Repository
   │
   │ git switch -c
   ▼
🌿 Feature Branch
   │
   │ ✏️ Make Changes
   ▼
📥 git add
   │
   ▼
💾 git commit
   │
   ▼
📤 git push
   │
   ▼
🔀 Pull Request
   │
   ▼
👀 Code Review
   │
   ▼
✅ Merge
```

---

# 🛠️ 27. Git Troubleshooting Quick Reference

### ❌ "Not a git repository"

```text
fatal: not a git repository
```

Check:

```bash
pwd
ls -la
git status
```

If needed:

```bash
git init
```

---

### ❌ "Remote origin already exists"

Check:

```bash
git remote -v
```

Change it:

```bash
git remote set-url origin <repository-url>
```

---

### ❌ Wrong Remote URL

```bash
git remote -v
```

Then:

```bash
git remote set-url origin https://github.com/USERNAME/REPOSITORY.git
```

---

### ❌ Push Rejected

First:

```bash
git pull --rebase origin main
```

Then:

```bash
git push origin main
```

---

### ❌ Accidentally Added a File

```bash
git restore --staged filename
```

---

# 🧩 28. Git Mental Model

Think about Git like this:

```text
📂 WORKING DIRECTORY
       │
       │ "I changed something"
       ▼
📥 STAGING AREA
       │
       │ "I want this in my next snapshot"
       ▼
💾 COMMIT
       │
       │ "Save this version"
       ▼
🗃️ LOCAL REPOSITORY
       │
       │ git push
       ▼
🌐 GITHUB
```

### 🧠 Easy Memory

```text
✏️ Edit
 ↓
📥 Add
 ↓
💾 Commit
 ↓
📤 Push
```

---

# 🎯 Git Commands to Learn First

### 🥇 Beginner

```bash
git init
git status
git add .
git commit -m "message"
git log --oneline
```

### 🥈 Intermediate

```bash
git branch
git switch
git merge
git remote -v
git pull
git push
git fetch
git stash
```

### 🥉 Advanced

```bash
git rebase
git cherry-pick
git reset
git revert
git reflog
git bisect
```

---

# 🔥 Quick Daily Git Checklist

```text
☐ 🔍 git status
☐ ✏️ Make changes
☐ 🔎 git diff
☐ 📥 git add .
☐ 🔍 git diff --staged
☐ 💾 git commit -m "message"
☐ 📜 git log --oneline
☐ 📤 git push
```

---

# 🌟 Golden Rules of Git

> 🟢 **Check before you change:** `git status`

> 🟢 **Review before committing:** `git diff`

> 🟢 **Write meaningful commit messages.**

> 🟢 **Make small, focused commits.**

> 🟢 **Pull/fetch before starting work when collaborating.**

> 🟢 **Don't commit secrets such as passwords, API keys, or `.env` files.**

> 🟢 **Be careful with `git reset --hard`, `git clean -f`, and force pushes.**

---

# 📚 Git Learning Progress

| Day    | Topic                  | Status      |
| ------ | ---------------------- | ----------- |
| Day 22 | 🚀 Git Introduction    | ✅ Completed |
| Day 23 | 🌿 Branching           | ⬜           |
| Day 24 | 🔀 Merge & Conflicts   | ⬜           |
| Day 25 | 🌐 Remote Repositories | ⬜           |
| Day 26 | 🔄 Rebase              | ⬜           |
| Day 27 | 🧳 Stash               | ⬜           |
| Day 28 | 🍒 Cherry-pick         | ⬜           |

---

# 🚀 Keep Learning Git!

Git is not just about remembering commands.

The real goal is to understand:

```text
🧠 What changed?
      ↓
📥 What should I stage?
      ↓
💾 What should I commit?
      ↓
🌿 Which branch should contain it?
      ↓
📤 What should I push?
      ↓
🔀 How should it be reviewed and merged?
```

> 💡 **Practice Git commands regularly. Break things, understand the error, and fix them. That's how Git becomes easy.**

---

## ❤️ #90DaysOfDevOps

**#Git #GitHub #DevOps #VersionControl #CI/CD #Linux #Cloud #90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham**

⭐ **This cheat sheet will be updated continuously as I learn new Git commands.**
