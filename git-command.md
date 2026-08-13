# Git Commands Reference

A personal Git command reference created during the #90DaysOfDevOps challenge.

## Q1.What is the difference between git add and git commit?

git add moves changes from the working directory into the staging area.
git commit takes the staged changes and saves them permanently as a snapshot in the Git repository.

Example
git add git-commands.md
git commit -m "Add Git commands reference"

So:

git add     → Select changes
git commit  → Save changes

## Q2. What does the staging area do?

The staging area allows us to choose exactly which changes should be included in the next commit.

Git does not directly commit every change because we may have multiple changes but only want to commit some of them.

Example

Suppose I modify:

application.yml
README.md
docker-compose.yml

I can stage only:

git add README.md

and commit only that change.

This gives better control over commits.

## Q3. What information does git log show?

git log displays the commit history of the repository.

It can show:

Commit ID
Author
Commit date
Commit message

Example:

git log

For a compact view:

git log --oneline

Example:

a12bc34 Update Git notes
d45ef67 Add Git commands
789abcd Initial commit
## Q4. What is the .git/ folder?

The .git directory is created when we run:

git init

It contains Git's internal repository information such as:

Commit objects
References
HEAD information
Repository configuration
Branch information

It is the main directory that makes the project a Git repository.

What happens if .git is deleted?

If the .git directory is deleted, the files in the project remain, but Git no longer recognizes that directory as a Git repository.

The previous local commit history and Git metadata are also lost from that repository.

## Q5. Difference between Working Directory, Staging Area and Repository
Working Directory

This is where I create and modify files.

Example:

git-commands.md
day-22-notes.md
Staging Area

This contains the changes selected for the next commit.

Command:

git add .
Repository

This contains the committed history of the project.

Command:

git commit -m "Add Git notes"
Git Workflow
              git add
Working ----------------→ Staging
Directory                 Area
                              |
                              | git commit
                              ↓
                         Repository


---

## 1. Setup & Configuration

### Check Git version

```bash
git --version
```

Shows the installed Git version.

**Example:**

```bash
git --version
```

---

### Configure username

```bash
git config --global user.name "Your Name"
```

Sets the username that Git uses for commits.

**Example:**

```bash
git config --global user.name "Tejswini Maingade"
```

---

### Configure email

```bash
git config --global user.email "your-email@example.com"
```

Sets the email associated with your Git commits.

**Example:**

```bash
git config --global user.email "tejswinimaingade@gmail.com"
```

---

### Check Git configuration

```bash
git config --list
```

Displays the current Git configuration.

**Example:**

```bash
git config --list
```

---

## 2. Repository Setup

### Initialize a repository

```bash
git init
```

Creates a new local Git repository.

**Example:**

```bash
mkdir devops-git-practice
cd devops-git-practice
git init
```

---

### Check repository status

```bash
git status
```

Shows modified files, untracked files, staged files, and the current branch.

**Example:**

```bash
git status
```

---

### View Git repository directory

```bash
ls -la
```

Shows hidden files and directories, including the `.git` directory.

**Example:**

```bash
ls -la
```

---

## 3. Basic Workflow

### Create a file

```bash
touch git-commands.md
```

Creates a new file.

---

### Add a file to staging

```bash
git add git-commands.md
```

Moves the specified file from the working directory to the staging area.

---

### Stage all changes

```bash
git add .
```

Stages all new, modified, and deleted files.

---

### Commit changes

```bash
git commit -m "Add Git commands reference"
```

Creates a permanent snapshot of the staged changes.

---

## 4. Viewing Changes

### Check current status

```bash
git status
```

Shows what has changed since the previous commit.

---

### View unstaged changes

```bash
git diff
```

Shows changes that are present in the working directory but are not staged.

---

### View staged changes

```bash
git diff --staged
```

Shows changes that have been added to the staging area.

---

### View commit history

```bash
git log
```

Displays detailed commit history.

---

### View compact commit history

```bash
git log --oneline
```

Displays commits in a short, easy-to-read format.

**Example:**

```text
a12bc34 Add Git workflow notes
d45ef67 Update Git commands
789abcd Initial Git repository
```

---

### Simple workflow

```bash
git status
git add .
git status
git commit -m "Meaningful commit message"
git log --oneline
```

---

## 6. Important Git Concepts

### Working Directory

The files and folders where you actually create and modify your project.

### Staging Area

The area where you select the changes that should be included in the next commit.

### Repository

The Git database containing your committed project history.

### `.git` Directory

The hidden directory created by `git init`.

It contains Git's internal information, including:

* Commit history
* Branch information
* Configuration
* Object database
* References

**Warning:** Deleting `.git` removes the Git repository information and commit history from that local directory.

---

## Day 22 Summary

Today I learned:

* What Git is
* How to configure Git
* How to create a repository
* How to check repository status
* How the staging area works
* How to create commits
* How to view commit history
* Difference between working directory, staging area, and repository
* Purpose of the `.git` directory

This file will be continuously updated as I learn more Git commands.

