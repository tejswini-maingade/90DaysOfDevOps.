# Day 41 – Triggers & Matrix Builds

## Task
Your pipeline runs on push. Today you learn **every way to trigger a workflow** and how to run jobs across multiple environments at once.

---

## Challenge Tasks

### Task 1: Trigger on Pull Request
1. Create `.github/workflows/pr-check.yml`
2. Trigger it only when a pull request is **opened or updated** against `main`
3. Add a step that prints: `PR check running for branch: <branch name>`
4. Create a new branch, push a commit, and open a PR
5. Watch the workflow run automatically

**Verify:** Does it show up on the PR page? - **Yes**

- After creating pull request
  
<img width="1919" height="850" alt="Screenshot 2026-09-10 135152" src="https://github.com/user-attachments/assets/c705a306-114a-4a7b-a3ab-2e5577b8ee2f" />


---

### Task 2: Scheduled Trigger
1. Add a `schedule:` trigger to any workflow using cron syntax
2. Set it to run every day at midnight UTC - (`0 0 * * *`)
3. Write in your notes: What is the cron expression for every Monday at 9 AM?
 > 0 9 * * 1


---

### Task 3: Manual Trigger
1. Create `.github/workflows/manual.yml` with a `workflow_dispatch:` trigger
2. Add an **input** that asks for an `environment` name (staging/production)
3. Print the input value in a step
4. Go to the **Actions** tab → find the workflow → click **Run workflow**

**Verify:** Can you trigger it manually and see your input printed?


<img width="1917" height="833" alt="Screenshot 2026-09-10 135401" src="https://github.com/user-attachments/assets/1a53d268-1e52-4878-a26b-471ae967af83" />

---

### Task 4: Matrix Builds
Create `.github/workflows/matrix.yml` that:
1. Uses a matrix strategy to run the same job across:
   - Python versions: `3.10`, `3.11`, `3.12`
2. Each job installs Python and prints the version
3. Watch all 3 run in parallel

Then extend the matrix to also include 2 operating systems — how many total jobs run now?

<img width="1919" height="879" alt="Screenshot 2026-09-10 135532" src="https://github.com/user-attachments/assets/3b9a51b3-f519-4ab4-968e-7026dd01a425" />

---

### Task 5: Exclude & Fail-Fast
1. In your matrix, **exclude** one specific combination (e.g., Python 3.10 on Windows)
- After adding exclude for python-3.10 on macos it skipped that job.
<img width="1919" height="867" alt="Screenshot 2026-09-10 141019" src="https://github.com/user-attachments/assets/f85da938-51fd-44ae-b675-ebdd606b4d00" />


2. Set `fail-fast: false` — trigger a failure in one job and observe what happens to the rest
 - `fail-fast: false`
<img width="1919" height="834" alt="Screenshot 2026-09-10 140305" src="https://github.com/user-attachments/assets/930c6914-f823-4be9-b56f-329c4216f42a" />


3. Write in your notes: What does `fail-fast: true` (the default) do vs `false`?

- `fail-fast: true`
<img width="1918" height="867" alt="Screenshot 2026-09-10 140936" src="https://github.com/user-attachments/assets/1d9bee31-01ed-4508-8aa3-3ca097d980da" />



- Observation

- `fail-fast: false`):
     - In the workflow, a failure was triggered for Python 3.11 using exit 1. 
     - As shown in the screenshot,the jobs (`windows-latest, 3.11`) and (`ubuntu-latest, 3.11`) `failed`,but the other jobs continued running and completed successfully.
     - This shows that `fail-fast: false` allows all matrix jobs to run even if some fail.

  - `fail-fast: true (default)`: If one job fails, the remaining matrix jobs are cancelled.
  - `fail-fast: false`: If one job fails, the other jobs continue running until completion.

---

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
