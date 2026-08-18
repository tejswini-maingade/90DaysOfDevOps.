# 🚀 Day 26 – GitHub CLI: Manage GitHub from Your Terminal

## 📌 Objective

Today I learned how to use GitHub CLI (gh) to manage GitHub repositories, issues, pull requests, GitHub Actions, Gists, releases and API calls directly from the terminal.

GitHub CLI is especially useful for DevOps because GitHub operations can be integrated into scripts and CI/CD automation without constantly switching to the browser.

---
## Challenge Tasks

### Task 1: Install and Authenticate
1. Install the GitHub CLI on your machine
2. Authenticate with your GitHub account
3. Verify you're logged in and check which account is active

<img width="1477" height="436" alt="Screenshot 2026-08-18 133001" src="https://github.com/user-attachments/assets/a7bc34e8-76c4-49a8-8a29-879a702a09bd" />
<img width="1487" height="133" alt="Screenshot 2026-08-18 133242" src="https://github.com/user-attachments/assets/6464e41a-bf45-4333-9ec8-534c86aa34c2" />
<img width="1533" height="817" alt="Screenshot 2026-08-18 135200" src="https://github.com/user-attachments/assets/30f3f6d4-2355-4f69-8e9c-62c7e81fb4fe" />

4. Answer in your notes: What authentication methods does `gh` support?
+ Browser-based OAuth
+ Personal Access Token (PAT)
+ SSH Key-based

---

### Task 2: Working with Repositories
1. Create a **new GitHub repo** directly from the terminal — make it public with a README
<img width="1452" height="373" alt="Screenshot 2026-08-18 135958" src="https://github.com/user-attachments/assets/504f3099-b34c-4c45-a6b8-636e4f7e7612" />

<img width="1919" height="755" alt="Screenshot 2026-08-18 135903" src="https://github.com/user-attachments/assets/f2cc7faa-4a39-42ca-ad41-38721821e8ff" />

2. Clone a repo using `gh` instead of `git clone`
   
<img width="1351" height="347" alt="Screenshot 2026-08-18 140139" src="https://github.com/user-attachments/assets/ccdda5cf-2e72-4da8-8772-091b5d4fce20" />

3. View details of one of your repos from the terminal
<img width="1361" height="349" alt="Screenshot 2026-08-18 140219" src="https://github.com/user-attachments/assets/af887767-2b5c-44e5-89d9-b0e81d1fc44c" />

4. List all your repositories
<img width="1919" height="394" alt="Screenshot 2026-08-18 140300" src="https://github.com/user-attachments/assets/95777caf-ece4-4830-a014-b76c11ab9179" />

5. Open a repo in your browser directly from the terminal
<img width="1869" height="754" alt="Screenshot 2026-08-18 140335" src="https://github.com/user-attachments/assets/ab74d7d0-29ea-420f-83d6-7a351ac77356" />

6. Delete the test repo you created (be careful!)
<img width="1779" height="345" alt="Screenshot 2026-08-18 141142" src="https://github.com/user-attachments/assets/bef09bc6-2b0a-4ba4-9b18-d3526089de01" />

---

### Task 3: Issues
1. Create an issue on one of your repos from the terminal — give it a title, body, and a label
<img width="1741" height="287" alt="Screenshot 2026-08-18 141508" src="https://github.com/user-attachments/assets/8aa05a07-3298-4389-8933-72f86e5e49ff" />
<img width="1916" height="557" alt="Screenshot 2026-08-18 141348" src="https://github.com/user-attachments/assets/93459fae-c965-4848-b0da-15423c1e2cd0" />

2. List all open issues on that repo
<img width="1459" height="203" alt="Screenshot 2026-08-18 141454" src="https://github.com/user-attachments/assets/5457a371-ca41-4720-bf65-40f0816cb5ea" />

3. View a specific issue by its number
4. Close an issue from the terminal
<img width="1288" height="168" alt="Screenshot 2026-08-18 141614" src="https://github.com/user-attachments/assets/81f1ab76-3b8d-4a43-8b25-728aec4b8cc7" />
<img width="1919" height="627" alt="Screenshot 2026-08-18 141634" src="https://github.com/user-attachments/assets/b2a9aca5-ceae-4355-ae2c-65ab432a08da" />

5. Answer in your notes: How could you use `gh issue` in a script or automation?
- By combining gh issue commands in a script,you can automatically:
        - Check open issues
        - Add comments
        - Close issues

    - Example:
        ```
        gh issue list --repo tejswini-maingade/day26-gh-cli-test
        gh issue comment 1 --repo tejswini-maingade/day26-gh-cli-test --body "Checked automatically."
        gh issue close 1 --repo tejswini-maingade/day26-gh-cli-test
        ```

  For Uninstall GITHUB from CLI

      ```winget uninstall GitHub.cli```
---

### Task 4: Pull Requests
1. Create a branch, make a change, push it, and create a **pull request** entirely from the terminal
<img width="1919" height="831" alt="Screenshot 2026-08-18 143840" src="https://github.com/user-attachments/assets/816612a1-84c9-4d24-a567-33577bf5b386" />

2. List all open PRs on a repo
```gh pr list```

4. View the details of your PR — check its status, reviewers, and checks
<img width="1347" height="175" alt="Screenshot 2026-08-18 144632" src="https://github.com/user-attachments/assets/f3d01bba-28c1-4b24-9583-7e4891080183" />

5. Merge your PR from the terminal
<img width="1919" height="443" alt="Screenshot 2026-08-18 144608" src="https://github.com/user-attachments/assets/0477e44a-ea7e-498a-bf36-64710d5645eb" />


6. Answer in your notes:
   - What merge methods does `gh pr merge` support?
     + Merge Commit
     + Squash and Merge
     + Rebase and Merge

   - How would you review someone else's PR using `gh`?
     + ```gh pr review <PR-number>```
---

### Task 5: GitHub Actions & Workflows (Preview)
1. List the workflow runs on any public repo that uses GitHub Actions
```gh run list --repo aws-containers/retail-store-sample-app```

2. View the status of a specific workflow run

<img width="1725" height="662" alt="Screenshot 2026-08-18 145322" src="https://github.com/user-attachments/assets/e4b73d49-164e-4c3a-aa6e-a74a7b458942" />
<img width="1788" height="423" alt="Screenshot 2026-08-18 145910" src="https://github.com/user-attachments/assets/f3e13162-e509-41a7-8317-bdf82cf4005f" />

3. Answer in your notes: How could `gh run` and `gh workflow` be useful in a CI/CD pipeline?
```gh run``` : Monitoring and Troubleshooting
+ gh run is focused on the execution of your pipelines. It is the command-line equivalent of the "Actions" tab in your browser.

```gh workflow``` : Management and Manual Control
+ gh workflow focuses on the definition and triggering of the pipelines. This is where you manage the "logic" of your CI/CD.

---

## 🧠 Key Learnings
GitHub CLI allows me to:
🔐 Authenticate with GitHub
📦 Create and clone repositories
🔎 View and search repositories
🐛 Create and manage issues
🔀 Create, review and merge pull requests
⚙️ Monitor GitHub Actions
🔌 Access the GitHub API
📝 Manage Gists
🚀 Manage releases
⚡ Create command aliases
## Most useful commands learned
- gh auth status
- gh repo create
- gh repo clone
- gh repo view
- gh repo list
- gh issue create
- gh issue list
- gh issue view
- gh issue close
- gh pr create
- gh pr list
- gh pr view

## 🎯 DevOps Takeaway

The biggest takeaway from Day 26 is that GitHub does not have to be managed only through the browser.

With GitHub CLI, many GitHub operations can be performed directly from the terminal and integrated into scripts, automation and CI/CD pipelines.

This makes gh a valuable tool for DevOps engineers working with repositories, pull requests, issues and GitHub Actions at scale.

---
