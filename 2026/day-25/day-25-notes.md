# Day 25 – Git Reset vs Revert & Branching Strategies
## 🎯 Objective

The goal of Day 25 was to understand how Git handles mistakes and how different branching strategies are used by development teams.

### Topics covered:

git reset
git revert
git reflog
GitFlow
GitHub Flow
Trunk-Based Development
Reset vs Revert
Branching strategy selection

--- 

## 🔄 Task 1 – Git Reset

I created three commits:

Commit A → Commit B → Commit C
`git reset --soft`

Command:

`git reset --soft HEAD~1`
Observation

The HEAD moved back by one commit, but the changes introduced by the removed commit remained staged.

Commit C
   ↓
Changes remain staged
Meaning

--soft changes the commit history while keeping the changes staged.

### OUTPUT

<img width="1919" height="445" alt="Screenshot 2026-08-17 145904" src="https://github.com/user-attachments/assets/6e71711b-aa9e-4729-b35d-654467a8bb03" />
<img width="1919" height="380" alt="Screenshot 2026-08-17 150108" src="https://github.com/user-attachments/assets/254a871e-ff27-41fc-a171-0f79c41a7ca9" />

### `git reset --mixed`

Command:

`git reset --mixed HEAD~1`
Observation

The HEAD moved back by one commit and the changes remained in the working directory, but they were unstaged.

Commit C
   ↓
Changes remain unstaged
Meaning

--mixed resets the commit and staging area but keeps the working-tree changes.

--mixed is also the default mode of git reset.

### OUTPUT

<img width="1288" height="363" alt="Screenshot 2026-08-17 150249" src="https://github.com/user-attachments/assets/e4387d95-0416-40a9-9575-c2bee977f1fe" />

### `git reset --hard`
Command:
`git reset --hard HEAD~1`

Observation

The commit was removed from the current branch history and the associated staged and working-tree changes were also removed.

Commit C
   ↓
Commit removed
Changes removed
Meaning

--hard changes:

HEAD
Staging area
Working directory

⚠️ This makes it the most destructive reset mode.

<img width="850" height="293" alt="Screenshot 2026-08-17 150419" src="https://github.com/user-attachments/assets/a13788cc-2053-420e-8132-2b585ce748af" />

### What is the difference between --soft, --mixed, and --hard?
- --soft :- it removes the commit, But keeps the changes staged
- --mixed:- it removes the commit and unstaged the changes
- --hard :- it delete the commit and make working direcotry clean

### Which one is destructive and why?
git --hard is distructive because it deletes commits + staging changes + working directory changes so data will loss

### When would you use each one?
- --soft : when i want to change commit message or keep changes staged
- -- mixed : when i want to re-edit files and re-stage file properly
- --hard : when i want to completely delete the changes nd clean the brnach

### Should you ever use git reset on commits that are already pushed?
No, Once commits are pushed, others may have already pulled and worked on them,so resetting them can cause confusion and conflicts.

---

## Task 2: Git Revert — Hands-On
1. first I make 3 commits (commit X, Y, Z)
<img width="1919" height="668" alt="Screenshot 2026-08-17 150914" src="https://github.com/user-attachments/assets/513f9770-aa7c-4341-b0b2-26577ef805bc" />

2. Revert commit Y (the middle one) — what happens? ```git revert 2136763```
<img width="1140" height="205" alt="Screenshot 2026-08-17 151126" src="https://github.com/user-attachments/assets/36e7886b-9757-4ec1-84ae-67edc0b6c793" />

+ A new commit is created that undoes the changes from commit Y. The original commit Y remains in the history, but its changes are reversed in the codebase.

3. Check `git log` — is commit Y still in the history?
+ Yes, commit Y is still in the history, but it has been reverted by a new commit that undoes its changes.

4. Answer in your notes:
   ### How is `git revert` different from `git reset`?
     + git reset removes commits from branch history and also delete when we use --hard
     + git revert does not commit that undoes the changes ,keep history safe

   ### Why is revert considered **safer** than reset for shared branches?
     + git revert is safer because it does not rewrite history it creates a new commit that undoes changes so everyone in the team stay in sync.
     + git reset changes hisotry and requires force push which can break other developers branches.

   ### When would you use revert vs reset?
    +  Will use git revert when i am working on a Shared Branches.
    +  Will use git reset when the commit is not Pushed yet.
---


### Task 3: Reset vs Revert — Summary
Create a comparison in your notes:

| | `git reset` | `git revert` |
|---|---|---|
| What it does | git reset moves the branch pointer and rewrites history | git revert creates a new commit that cancels the previous one |
| Removes commit from history? | Yes | No |
| Safe for shared/pushed branches? | No | Yes |
| When to use | When working on locally and commit is not pushed yet | When working on shered or pushed branches |

---

### 🏆Task 4: Branching Strategies
Research the following branching strategies and document each in your notes with:
- How it works (short description)
- A simple diagram or flow (text-based is fine)
- When/where it's used
- Pros and cons
<img width="3424" height="3917" alt="image" src="https://github.com/user-attachments/assets/da3bcc72-0137-4ca2-b94b-ecaf0d309014" />

  1. **GitFlow** — develop, feature, release, hotfix branches
1. **GitFlow**
    **How it works:**

    - `main`      : Contains production-ready code.Every commit here is a stable release.
        
    - `develop`   : The integration branch where new features are merged before they’re ready to go live.
    
    - `feature`   : For building out new functionality.Created from develop and merged back when complete.
        
    - `release`   : Used to prep a new version for production.Created from develop and merged into both main and develop.

    - `hotfix`   : For urgent fixes on production.Created from main,then merged back into both main and develop.

    **Text Diagram:**
    ```text
    [main] (Production-ready)
    |
    o <----------------------------------------- (Start)
    | \
    |  \ [develop] (Integration)
    |   |
    |   o <------------------------------------- (Develop Start)
    |   | \
    |   |  \ [feature/login] (New functionality)
    |   |   |
    |   |   o (Feature Commit)
    |   |   |
    |   |   o (Feature Complete)
    |   |  /
    |   o / (Merge feature to develop)
    |   |
    |   | \
    |   |  \ [release/1.0] (Prep for production)
    |   |   |
    |   |   o (Release Prep/Bug Fix)
    |   |   |
    |   |   o (Release Ready)
    |   |  / \
    |   o /   o (Merge release to develop)
    |  /
    o / (Merge release to main & tag v1.0)
    |
    | \
    |  \ [hotfix/1.0.1] (Urgent fix)
    |   |
    |   o (Apply Fix)
    |  / \
    o /   o (Merge hotfix to develop)
    |
    V
    ```

    **When/where it's used:**

    - Team follows scheduled release cycles

    - Need to maintain multiple versions

    **Pros:** 
    - Clear separation of concerns across features, releases and hotfixes.

    **Cons:** 
    - Can result in long-lived branches, increasing the risk of merge conflicts.

2. **GitHub Flow** — simple, single main branch + feature branches
   **How it works:**

    - Create a `feature branch` from `main`
    - Push commits to the `feature branch`
    - Open a pull request for code review and automated tests.
    - Once approved, merge back to `main`.
    - Deploy immediately.
    - Everything in main should always be production-ready.

    **Text Diagram:**
    ```text  
   
      [main] (Always Production-Ready)
        |
        o (Start)
        |
        |\_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
        |                               \
        |                                \ [feature/login]
        |                                 |
        |                                 o (Commit 1)
        |                                 |
        |                                 o (Commit 2)
        |                                 |
        |                                 o (Pull Request & Review)
        |<_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _/
        |                               
        o (Merge & Auto-Deploy)
        |
        v
    ```

    **When/where it's used:**
    - ship frequent, small releases

     **Pros:**
    - Fast merge & deploy
    
     **Cons:**
     - In large teams, it can result in frequent merge conflicts

3. **Trunk-Based Development** — everyone commits to main, short-lived branches
**How it works:**

    - There’s one `main` branch, often called main or trunk. All development happens here
    - Developers commit directly to `main`, often multiple times per day
    - Changes are small, incremental

     **Text Diagram:**
     ```text
      [main] (The Trunk)
        |
        o (Start)
        |
        |\_ _ _ _ _ _ _ 
        |             \
        |              o (Dev A: Small Change)
        |<_ _ _ _ _ _ /
        |             /
        o (Merge & Test)
        |
        |\_ _ _ _ _ _ _ 
        |             \
        |              o (Dev B: Small Change)
        |<_ _ _ _ _ _ /
        |             /
        o (Merge & Test)
        |
        v
    ```

4. Answer:
   - Which strategy would you use for a startup shipping fast?
     + I would use Trunk-Based Development for a startup that needs to ship fast
   
   - Which strategy would you use for a large team with scheduled releases?
    + GitFlow

<img width="1362" height="741" alt="image" src="https://github.com/user-attachments/assets/bf226bfb-2fef-4d50-bb7b-f4ebb63abeca" />

---

🎯 Final Takeaway

The biggest lesson from Day 25 is:

Use reset carefully for local/private history, and prefer revert when undoing changes on shared branches.

Understanding branching strategies is equally important because the right workflow helps teams balance development speed, code quality, releases, and collaboration.
