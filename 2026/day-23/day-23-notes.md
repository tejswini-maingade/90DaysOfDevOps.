# 🚀 Day 23 – Git Branching & Working with GitHub

## 🎯 Challenge Tasks

### 🌿 Task 1: Understanding Branches

Answer these in your `day-23-notes.md`:

1. 🔹 What is a branch in Git?
2. 🔹 Why do we use branches instead of committing everything to `main`?
3. 🔹 What is `HEAD` in Git?
4. 🔹 What happens to your files when you switch branches?

## 📝 Answer->

# 1. 🌿 What is a branch in Git?
+ 🔹 A branch is a parallel workspace that lets you work on new features or fixes without touching the stable "main" code.
+ 🔹 Meanwhile a brach is a movaable pointer to a specific commit.
💡 Why it helps: It keeps your project organized and lets you experiment safely. If a branch breaks, you just delete it; your main code stays perfect.

# 2. 🛡️ Why do we use branches instead of committing everything to `main`?
+ 🔹 Branches let us work on new features or fixes safely without breaking main branch, which always holds the stable, production-ready code.
+ 🔹 Main branch is highly important and stable so its best practice to not interrupt it.

# 3. 📍 What is `HEAD` in Git?
+ 🔹 HEAD is a pointer that tells you where you are currently working.
+ 🔹 It always points to the latest commit on the branch you are working on.

# 4. 🔄 What happens to your files when you switch branches?
+ 🔹 Git updates your project files to look like the branch you switched to.
+ 🔹 Files that exist in the current branch but not in the new branch will disappear temporarily.
+ 🔹 Files that are different in the new branch will be replaced with the new branch version.

---

### 🌿 Task 2: Branching Commands — Hands-On

In your `devops-git-practice` repo, perform the following:

1. 📋 List all branches in your repo
- `git branch`

<img width="1915" height="506" alt="Screenshot 2026-08-14 124506" src="https://github.com/user-attachments/assets/dd34b09c-d417-4f53-9387-13f3777ee6b4" />


2. 🌱 Create a new branch called `feature-1`
- `git branch feature-1`

<img width="1053" height="262" alt="Screenshot 2026-08-14 124635" src="https://github.com/user-attachments/assets/e22b9578-b95f-4a28-aed2-7808a4d49869" />


3. 🔀 Switch to `feature-1`
- `git switch feature-1`

<img width="1629" height="179" alt="Screenshot 2026-08-14 125212" src="https://github.com/user-attachments/assets/a40ca041-c1e5-4555-9452-6758e56dcfa3" />

4. 🌱 Create a new branch and switch to it in a single command — call it `feature-2`
- `git checkout -b feature-2`

<img width="1045" height="96" alt="Screenshot 2026-08-14 124822" src="https://github.com/user-attachments/assets/eb9a3294-9f45-4380-908c-0f322c765808" />

5. 🔄 Try using `git switch` to move between branches — how is it different from `git checkout`?
- `git switch <branch>`   :only switches branches.  
- `git checkout <branch>` :switches branches and can also restore files.



6. 📝 Make a commit on `feature-1` that does **not** exist on `main`
- `git commit -m "Add git branch command section to git-commands.md"`

<img width="1598" height="162" alt="Screenshot 2026-08-14 125109" src="https://github.com/user-attachments/assets/d99b8631-249b-48dd-90fb-492818aa24d5" />

7. 🔙 Switch back to `main` — verify that the commit from `feature-1` is not there


9. 🗑️ Delete a branch you no longer need
- `git branch -d feature-2`
  
<img width="1489" height="322" alt="Screenshot 2026-08-14 125326" src="https://github.com/user-attachments/assets/aa6fe625-3488-4159-827d-2f58a29a1c38" />


9. 📚 Add all branching commands to your `git-commands.md`

---

### 🚀 Task 3: Push to GitHub

1. 🆕 Create a **new repository** on GitHub (do NOT initialize it with a README)

<img width="1919" height="866" alt="Screenshot 2026-08-14 125453" src="https://github.com/user-attachments/assets/f2ef3e26-a30c-420c-883b-5d3eb2b96391" />


2. 🔗 Connect your local `devops-git-practice` repo to the GitHub remote
<img width="1303" height="174" alt="Screenshot 2026-08-14 141855" src="https://github.com/user-attachments/assets/db4a24a5-3fbd-424a-8feb-0be2e8d8a2c3" />


3. ⬆️ Push your `main` branch to GitHub
4. ⬆️ Push `feature-1` branch to GitHub
   
<img width="1882" height="652" alt="Screenshot 2026-08-14 142053" src="https://github.com/user-attachments/assets/25b06538-f28f-4ea4-b84b-544a871cd2ee" />


6. ✅ Verify both branches are visible on GitHub

<img width="1311" height="600" alt="Screenshot 2026-08-14 142235" src="https://github.com/user-attachments/assets/ec0349e9-dfdc-4e3c-8863-d18d358af96c" />


6. 📌 Answer in your notes: What is the difference between `origin` and `upstream`?

- 🔹 `origin`: origin is the default name for the repo you cloned,points to your own GitHub repository where you push and pull changes.
`example`: https\://github.com/amit5197/devops-git-practice.git
- 🔹 `upstream`: upstream refers to the original repository you forked from.You use it to pull updates from the original project into your fork.
`example`: https\://github.com/amit5197/90DaysOfDevOps

---

### 🔄 Task 4: Pull from GitHub

1. ✏️ Make a change to a file **directly on GitHub** (use the GitHub editor)

2. ⬇️ Pull that change to your local repo

<img width="1336" height="574" alt="Screenshot 2026-08-14 142745" src="https://github.com/user-attachments/assets/32dca3bb-31ee-4ddf-b24d-da438bbee8a3" />

3. 📚 Answer in your notes: What is the difference between `git fetch` and `git pull`?

- 🔹 `git fetch` : Downloads changes from remote only; does not change your branch,just updates remote info.
  or `Git fetch` goes to the remote server (GitHub) and downloads all the new data.
  💡 What it does: Updates your remote-tracking branches (like `origin/main` ).
- 🔹 `git pull` : Downloads changes from remote and merges them into your current branch, updating your local branch immediately.
  💡 What it does: It downloads the new data AND tries to automatically stitch it into your current files.
  
---

### 🔀 Task 5: Clone vs Fork

1. 📥 **Clone** any public repository from GitHub to your local machine

2. 🍴 **Fork** the same repository on GitHub, then clone your fork

- 🔹 `clone` : Download the project from GitHub to my computer.
- 🔹 `fork` : Make my own copy in of someone else’s project on GitHub.

3. 📝 Answer in your notes:

   1- 🔍 What is the difference between clone and fork?
   
         - 🔹 `clone` : Download the project from GitHub to my computer.
         - 🔹 `fork` : Make my own copy in of someone else’s project on GitHub.
     
   2- 🎯 When would you clone vs fork?
   
         - `clone when`:
             - ✅ You are working on your own project.
             - ✅ You already have write access.
             - ✅ You just want the code locally.
             - 💡 Example: Working in your company repo where you’re a team member.
   
        - `fork when`
             - ❌ You don’t have write access.
             - 🌍 You want to contribute to open source.
             - 🛡️ You want your own safe copy.
             - 💡 Example: Contributing to aws-containers repository retail-store-sample-app.


  3- 🔄 You don’t have write access.
         - 🌍 You want to contribute to open source.
         - 🛡️ You want your own safe copy.
         - 💡 Example: Contributing to aws-containers repository Uptime-kuma
   - 🔄 After forking, how do you keep your fork in sync with the original repo?

   - 🔗 After forking and cloning my fork, I add the original repository as an script.js remote. Then I fetch changes from script.js, merge the script.js default branch into my current branch,and push the updates to my fork.

      - 💻 Example:
        ```
        git remote add upstream git@github.com:Amit5197/Uptime-Kuma.git
        git checkout main
        git fetch script.js
        git merge script.js/main
        git push origin main
        ```
---
