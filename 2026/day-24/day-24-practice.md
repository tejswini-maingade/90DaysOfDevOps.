# 🚀Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

## 🎯 Challenge Tasks

### 🔀 Task 1A: Git Merge — Hands-On
1. Create a new branch `feature-login` from `main`, add a couple of commits to it

```
# Create and switch to the new branch
` git checkout -b feature-login `

# Create a file and commit
` echo "This is my login page" > login.txt `
` git add login.txt ` 
` git commit -m "Add login logic" `

# Add a second commit
echo "Login styles" >> login.txt
git commit -am "Add login styles"
```
<img width="1538" height="659" alt="Screenshot 2026-08-16 120011" src="https://github.com/user-attachments/assets/254598a2-85ea-401f-a21b-0ac11a7e9485" />
<img width="1329" height="534" alt="Screenshot 2026-08-16 120141" src="https://github.com/user-attachments/assets/89aff806-28f7-4c9d-8f56-8beb0664c8e7" />

2. Switch back to `main` and merge `feature-login` into `main`
# Switch back to main
` git checkout main `

# Merge the feature branch
` git merge feature-login `

3. Observe the merge — did Git do a **fast-forward** merge or a **merge commit**?
` fast-forward `
+ What happened? You will likely see the message Fast-forward.
Since main had no new commits of its own, Git didn't need to combine any divergent histories; it just pointed main to the same commit as feature-login.



<img width="1199" height="485" alt="Screenshot 2026-08-16 120650" src="https://github.com/user-attachments/assets/3f8f416c-7678-4b55-9018-fd6846cbb249" />

4. Now create another branch `feature-signup`, add commits to it — but also add a commit to `main` before merging

<img width="1407" height="642" alt="Screenshot 2026-08-16 121117" src="https://github.com/user-attachments/assets/94c54fac-599c-4f0a-a4fd-d6fd35c9b561" />

5. Merge `feature-signup` into `main` — what happens this time?

# Merge feature-signup into main
` git merge feature-signup `

## ⚔️Task 1B — Force a Merge Commit

Now we'll create the situation where branches diverge.

Step 1: Create feature-signup
` git switch -c feature-signup `

Step 2: Create a file:

`echo "This is my signup page" > signup.txt`
` git add signup.txt`
`git commit -m "Add signup page"`

<img width="1407" height="642" alt="Screenshot 2026-08-16 121117" src="https://github.com/user-attachments/assets/19cccad3-f87d-48e0-812c-c1ef5c00350c" />

Step 3: Add another commit:
`echo "Signup validation" >> signup.txt`
`git add signup.txt`
`git commit -m "Add signup validation"`

<img width="1519" height="543" alt="Screenshot 2026-08-16 121258" src="https://github.com/user-attachments/assets/73d5adc8-f50a-4007-8a1c-c289ba29f1c3" />

Step 4: Go to main
`git switch main`
Step 5: Now make a commit on main:

`echo "Main branch update" > main-update.txt`
`git add main-update.txt`
`git commit -m "Update main branch"`

<img width="1447" height="618" alt="Screenshot 2026-08-16 121514" src="https://github.com/user-attachments/assets/4e28e413-eb4b-43ea-86e3-978758aef3ae" />

Step 6: Merge signup
`git merge feature-signup`

This time Git should create a merge commit.
`git log --oneline --graph --all`
<img width="1195" height="467" alt="Screenshot 2026-08-16 121735" src="https://github.com/user-attachments/assets/c8dcd9e6-85be-4726-ae09-558157cf31fd" />

## ⚔️Task 1C — Create a Merge Conflict
1. First create a file on main: i.e conflict.txt
<img width="1335" height="566" alt="Screenshot 2026-08-16 122615" src="https://github.com/user-attachments/assets/ae5bd2f4-674d-4a50-aff8-4b8143cd23d4" />

2. Create a branch: feature-conflict
<img width="1153" height="91" alt="Screenshot 2026-08-16 122624" src="https://github.com/user-attachments/assets/cc0b3492-0a91-4ad0-a5ac-53041435091b" />

3. Change the same line
  <img width="1131" height="514" alt="Screenshot 2026-08-16 122806" src="https://github.com/user-attachments/assets/6ebaf2e8-148d-4b82-8f04-e2b14d3aa400" />

4. git switch main
5. Change the same line differently
6. Now merge:
<img width="1280" height="641" alt="Screenshot 2026-08-16 123341" src="https://github.com/user-attachments/assets/fdd8fee3-0128-4948-b6e1-c0656be53bd0" />
<img width="854" height="160" alt="Screenshot 2026-08-16 123407" src="https://github.com/user-attachments/assets/d9dfb746-9f37-4959-ae6b-6235e53ebac4" />

7. Choose the version you want and add and commit this file.
8. Now you see merge conflict resolved.
 <img width="1114" height="360" alt="Screenshot 2026-08-16 123848" src="https://github.com/user-attachments/assets/f9fe96d7-1355-4e58-9a71-b98e1399c876" />

---

### 🔄Task 2: Git Rebase — Hands-On
1. Create a branch `feature-dashboard` from `main`, add 2-3 commits
+ Create a branch feature-dashboard from main, add 2-3 commits
  + ``` git checkout -b feature-dashboard ```

<img width="1212" height="449" alt="Screenshot 2026-08-16 124340" src="https://github.com/user-attachments/assets/7d9bcd72-ce71-476e-b16e-7493fae9f716" />
2.While on main, add a new commit (so main moves ahead)

<img width="1119" height="269" alt="Screenshot 2026-08-16 124548" src="https://github.com/user-attachments/assets/c83f51b2-f374-4468-bcb4-6a3724d822b7" />

3.Switch to feature-dashboard and rebase it onto main
`git checkout -b feature-dashboard`
`git rebase main`
4. Observe your git log --oneline --graph --all — how does the history look compared to a merge?
   git merge creates a branching history with a merge commit while rebase creates a linear history by rewriting commits without merge commit.
<img width="1285" height="647" alt="Screenshot 2026-08-16 124634" src="https://github.com/user-attachments/assets/df521e29-903c-41e8-b49e-5266fbd4dd78" />

5. Answer in your notes:
   - What does rebase actually do to your commits?
      - Rebase "rewrites history" by taking your feature-dashboard branch commits and replaying them one by one on top of the latest version of main.
      or- Rebase rewrites your commits by replaying them on top of another branch , creating new commit ids and changing their base.
      or - Git Rebase is the process of moving or combining a sequence of commits to a new base commit. It effectively "rewrites" the history of your branch.

    - How is the history different from a merge?
      - `merge`preserves history exactly as it happened.creates a merge commit.
      - `rebase`rewrites history. moves your commits on top of feature-dashboard branch,creates a linear,clean history.no merge commit.
      - or difference between Merge and Rebase lies in how they treat time and the "story" of your project.
   
   - Why should you **never rebase commits that have been pushed and shared** with others?
      - because rebase changes commit id's, if others pulled the old commits:their history won’t match yours anymore causes conflicts,duplicated commits.

   - When would you use rebase vs merge?

      - `rebase`: keeping history linear
      or- we can rebase when we are working on private or a local branch
      - `merge`: working on shared branches.you want full history preserved.
      or- merge for safe collabration and shared branches

---

### 🧹Task 3: Squash Commit vs Merge Commit
1. Create a branch `feature-profile`, add 4-5 small commits (typo fix, formatting, etc.)
<img width="1406" height="577" alt="Screenshot 2026-08-16 125324" src="https://github.com/user-attachments/assets/0d4ea314-8214-4b15-9de8-50c2d65f20dc" />

2. Merge it into `main` using `--squash` — what happens?
3. Check `git log` — how many commits were added to `main`?
<img width="1161" height="642" alt="Screenshot 2026-08-16 125607" src="https://github.com/user-attachments/assets/4ef65d28-a8c3-4557-9988-d6220386cf42" />
   
4. Now create another branch `feature-settings`, add a few commits
5. Merge it into `main` **without** `--squash` (regular merge) — compare the history
<img width="1437" height="533" alt="Screenshot 2026-08-16 130038" src="https://github.com/user-attachments/assets/becb2649-88f4-46ac-8d29-ce70d26c75a1" />
<img width="928" height="460" alt="Screenshot 2026-08-16 130047" src="https://github.com/user-attachments/assets/83024e38-f3bd-492c-9c33-2aadde4cc54d" />

6. Answer in your notes:

   - What does squash merging do?
   + A sqaush merge applies the changes of a branch but not its individual commit history

   - When would you use squash merge vs regular merge?
    + use squash merge for a clean, simplified history.
    + and use regular merge when you need to preserve full commit history.
   
   - What is the trade-off of squashing?
   + `trade-off` squashing is cleaner history at the cost if losing detailed commit .
   + or - The `trade-off` of squashing is that while it keeps the main branch history clean and linear,it removes the detailed commit history of the feature branch by combining everything into a single commit.

---

### 📦 Task 4: Git Stash — Hands-On
1. Start making changes to a file but **do not commit**
2. Now imagine you need to urgently switch to another branch — try switching. What happens?
3. Use `git stash` to save your work-in-progress
4. Switch to another branch, do some work, switch back
5. Apply your stashed changes using `git stash pop`
6. Try stashing multiple times and list all stashes
7. Try applying a specific stash from the list
   
 <img width="1259" height="513" alt="Screenshot 2026-08-16 130607" src="https://github.com/user-attachments/assets/346c15a1-a224-4970-93f1-acc79e71e098" />

8. Answer in your notes:
   - What is the difference between `git stash pop` and `git stash apply`?

      `git stash pop`: brings your stashed changes back to your working directory.deletes that entry from your stash list immediately.

      `git stash apply`: brings the stashed changes back to your working directory.keeps the entry in your stash list.

   - When would you use stash in a real-world workflow?
      - If I’m working on a feature and need to urgently switch branches to fix a production bug,I would use git stash to temporarily save my unfinished changes before switching.

---

### 🍒Task 5: Cherry Picking
1. Create a branch `feature-hotfix`, make 3 commits with different changes
 <img width="1236" height="400" alt="Screenshot 2026-08-16 132254" src="https://github.com/user-attachments/assets/9769e3c0-6f76-4892-98ec-87d17b5a2cba" />
2. Switch to `main`
3. Cherry-pick **only the second commit** from `feature-hotfix` onto `main`
4. Verify with `git log` that only that one commit was applied  
<img width="1914" height="260" alt="Screenshot 2026-08-16 132635" src="https://github.com/user-attachments/assets/f0ab4424-6a43-48bc-b78d-c52925abee38" />
<img width="965" height="476" alt="Screenshot 2026-08-16 133224" src="https://github.com/user-attachments/assets/aa5210a0-fc84-4545-ae39-7e77cc5b7ef5" />
6. Answer in your notes:
   - What does cherry-pick do?
   + git cherry-pick is like copy-pasting a specific commit from one branch to another.
   + or - copy a specific commit from one branch and apply it onto our current branch.
    
   - When would you use cherry-pick in a real project?
   + when i need specific commit but do not want the enitre branch to be commit.
     
   - What can go wrong with cherry-picking?
   + merge conflicts if same file was modified.
   + Commit history confusion because it creates new commit ids.

---

