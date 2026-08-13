# 🚀 Day 22 – Introduction to Git: Your First Repository

> 💡 **What is Git?**
>
> Git is a **Distributed Version Control System (DVCS)** that tracks changes made to files, maintains version history, and helps developers collaborate effectively.

---

## ⚙️ Task 1: Install and Configure Git

### 🎯 Objectives

1. ✅ Verify Git is installed on the machine.
2. 👤 Set up Git identity — name and email.
3. 🔍 Verify the Git configuration.

### 💻 Commands Used

```bash
git --version

git config --global user.name "Your Name"

git config --global user.email "your-email@example.com"

git config --global --list
```

### 📸 Output

<img width="1178" height="217" alt="Git Configuration" src="https://github.com/user-attachments/assets/28fba70c-f9e8-4fad-803c-ba845a38f954" />

---

## 📁 Task 2: Create Your Git Project

### 🎯 Objectives

1. 📂 Create a folder called `devops-git-practice`.
2. 🚀 Initialize it as a Git repository.
3. 🔍 Check the repository status.
4. 👀 Explore the hidden `.git/` directory.

### 💻 Commands Used

```bash
mkdir devops-git-practice

cd devops-git-practice

git init

git status

ls -la
```

### 💡 What I Learned

* 🚀 `git init` initializes a new Git repository.
* 🔍 `git status` shows the current state of the repository.
* 📦 `.git/` contains Git's internal repository information.
* 👻 `ls -la` displays hidden files and directories.

### 📸 Screenshots

<img width="1086" height="626" alt="Git Repository Initialization" src="https://github.com/user-attachments/assets/7aec2d1a-ec25-4072-ba0f-3b6015117ddc" />

<img width="812" height="270" alt="Git Status and .git Directory" src="https://github.com/user-attachments/assets/42c313f8-d6ce-4c55-926f-cc98d5c76efc" />

---

# 📝 Task 3: Create Your Git Commands Reference

Created:

```text
📄 git-commands.md
```

The commands are organized into:

* ⚙️ **Setup & Config**
* 🔄 **Basic Workflow**
* 🔍 **Viewing Changes**

---

## ⚙️ Setup & Config

### 🚀 `git init`

Initializes a new Git repository.

**Example:**

```bash
git init
```

---

### ⚙️ `git config`

Configures Git username and email.

**Example:**

```bash
git config --global user.name "Your Name"

git config --global user.email "Your Email"
```

### 🔍 View Configuration

```bash
git config --global --list
```

Displays the configured Git settings.

---

# 🔄 Basic Workflow

### 📥 `git add`

Stages files for the next commit.

**Example:**

```bash
git add git-commands.md
```

To stage all changes:

```bash
git add .
```

---

### 💾 `git commit`

Saves staged changes with a message explaining what was changed.

**Example:**

```bash
git commit -m "Add Git commands reference"
```

---

# 🔍 Viewing Changes

### 📊 `git status`

Shows which files are:

* 🆕 Untracked
* ✏️ Modified
* 📥 Staged
* ✅ Ready to commit

**Example:**

```bash
git status
```

---

### 📜 `git log`

Shows the commit history of the repository.

It can display:

* 🔑 Commit hash
* 👤 Author
* 📅 Date
* 📝 Commit message

**Example:**

```bash
git log
```

### ⚡ Compact History

```bash
git log --oneline
```

---

# 📦 Task 4: Stage and Commit

### 1️⃣ Stage the file

```bash
git add git-commands.md
```

### 2️⃣ Check what is staged

```bash
git status
```

Example:

```text
On branch master

No commits yet

Changes to be committed:

    new file: git-commands.md
```

### 3️⃣ Create the commit

```bash
git commit -m "Initial Git command reference"
```

### 4️⃣ View commit history

```bash
git log
```

---

# 🔄 Task 5: Make More Changes and Build History

### 🎯 Objectives

1. ✏️ Edit `git-commands.md`.
2. 🔍 Check what changed.
3. 📥 Stage the changes.
4. 💾 Commit with a descriptive message.
5. 🔁 Repeat at least **3 times**.
6. 📜 View the complete history using `git log --oneline`.

### 💻 Workflow

```bash
git status

git diff

git add .

git status

git commit -m "Update Git commands"

git log --oneline
```

### 📸 Commit History

<img width="1192" height="328" alt="Git Commit History" src="https://github.com/user-attachments/assets/302f1cb3-191e-4b29-bcfc-5fc0a7b2c08f" />

### 💡 What I Learned

Creating multiple commits helped me understand how Git tracks changes over time.

Each commit acts as a **checkpoint** that represents the state of the project at a specific point in time.

---

# 🧠 Task 6: Understand the Git Workflow

## 1️⃣ What is the difference between `git add` and `git commit`?

### 📥 `git add`

`git add` tells Git which changes should be included in the next commit.

It moves changes from the **Working Directory → Staging Area**.

```bash
git add filename
```

### 💾 `git commit`

`git commit` saves the staged changes as a permanent snapshot in the Git repository.

```bash
git commit -m "Meaningful commit message"
```

### 💡 In Simple Words

```text
git add     → 📥 Select changes
git commit  → 💾 Save changes
```

---

## 2️⃣ What does the Staging Area do?

The **Staging Area** is a preparation area between the Working Directory and Repository.

Think of it as a **🪑 waiting room for changes**.

It allows us to choose exactly which changes should be included in the next commit.

### Why is it useful?

* 🎯 Select specific changes.
* 🧹 Create clean commits.
* 📦 Group related changes.
* 🔍 Review changes before committing.

---

## 3️⃣ What information does `git log` show?

`git log` displays the commit history of the repository.

It can show:

* 🔑 Commit ID / Hash
* 👤 Author
* 📅 Date
* 📝 Commit message

### Example

```bash
git log
```

For compact history:

```bash
git log --oneline
```

Example:

```text
a12bc34 Update Git notes
b45cd67 Add Git commands
c78de90 Initial commit
```

---

## 4️⃣ What is the `.git/` folder?

The `.git/` folder is created when we run:

```bash
git init
```

It contains Git's internal repository information, including:

* 📜 Commit objects
* 🌿 Branch information
* 🏷️ Tags
* ⚙️ Repository configuration
* 📌 HEAD information
* 🗃️ Git metadata

### ⚠️ What happens if `.git/` is deleted?

If `.git/` is deleted:

* 📁 Project files remain.
* ❌ Git no longer recognizes the directory as a repository.
* 🗑️ Local Git history and metadata are lost.

> ⚠️ **Never delete `.git/` unless you intentionally want to remove the local Git repository.**

---

# 🔄 5️⃣ Working Directory vs Staging Area vs Repository

## 📂 Working Directory

The **Working Directory** is where we create and modify project files.

Example:

```text
devops-git-practice/
├── 📄 git-commands.md
└── 📄 day-22-notes.md
```

---

## 📥 Staging Area

The **Staging Area**, also called the **Index**, is the preparation zone between the Working Directory and Repository.

When we run:

```bash
git add .
```

the selected changes are added to the Staging Area.

---

## 🗃️ Repository

The **Repository** contains the committed project history.

Git stores this information inside:

```text
.git/
```

When we run:

```bash
git commit -m "Add Git notes"
```

the staged changes are recorded as a new commit.

---

# 🔄 Git Workflow

```text
📂 Working Directory
       │
       │ ✏️ Edit files
       │
       │ git add
       ▼
📥 Staging Area
       │
       │ 🔍 Review / Prepare
       │
       │ git commit
       ▼
🗃️ Repository
       │
       │ 📜 Permanent History
       ▼
🌐 GitHub
```

### ⭐ In One Line

```text
📂 Working Directory → 📥 git add → 🗃️ Staging Area → 💾 git commit → 📜 Repository → 🌐 GitHub
```

---

# 📚 Commands Practiced Today

```bash
git --version

git config --global user.name "Your Name"

git config --global user.email "your-email@example.com"

git config --global --list

git init

git status

git add .

git add <filename>

git commit -m "commit message"

git log

git log --oneline

ls -la
```

---

# 🎯 Key Learnings

Today I learned the fundamentals of Git:

* 🚀 Git is a Distributed Version Control System.
* 📁 `git init` creates a new Git repository.
* 🔍 `git status` shows the current repository state.
* 📥 `git add` moves changes to the Staging Area.
* 💾 `git commit` saves staged changes as a snapshot.
* 📜 `git log` displays commit history.
* 🗃️ `.git/` contains Git's internal repository information.
* 🎯 The Staging Area gives control over what goes into a commit.
* 🔄 Multiple commits create a useful project history.

---

# ✅ Day 22 Completed

I successfully created my first Git repository and practiced the basic Git workflow:

```text
📂 Create
   ↓
✏️ Modify
   ↓
📥 git add
   ↓
📦 Staging Area
   ↓
💾 git commit
   ↓
🗃️ Repository
   ↓
📜 git log
   ↓
🌐 GitHub
```

I will continue updating my `git-commands.md` file as I learn new Git commands throughout the upcoming #90DaysOfDevOps challenges.

---

## 🌟 Happy Learning! 😊

**#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham #Git #DevOps #VersionControl**
