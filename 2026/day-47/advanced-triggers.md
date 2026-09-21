# Day 47 – Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines

## Task
You've used `push` and basic `pull_request` triggers. But GitHub Actions supports **dozens of event types** — today you go deep into PR lifecycle events, scheduled cron jobs, and chaining workflows together.

---

## Challenge Tasks

### Task 1: Pull Request Event Types
Create `.github/workflows/pr-lifecycle.yml` that triggers on `pull_request` with **specific activity types**:
1. Trigger on: `opened`, `synchronize`, `reopened`, `closed`
2. Add steps that:
   - Print which event type fired: `${{ github.event.action }}`
   - Print the PR title: `${{ github.event.pull_request.title }}`
   - Print the PR author: `${{ github.event.pull_request.user.login }}`
   - Print the source branch and target branch
3. Add a conditional step that only runs when the PR is **merged** (closed + merged = true)

Test it: create a PR, push an update to it, then merge it. Watch the workflow fire each time with a different event type.

[pr-lifecycle.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/pr-lifecycle.yml)

<img width="1919" height="869" alt="Screenshot 2026-09-21 151154" src="https://github.com/user-attachments/assets/0b773a20-32a9-4fde-8b30-f585efe96f19" />

---

### Task 2: PR Validation Workflow
Create `.github/workflows/pr-checks.yml` — a real-world PR gate:
1. Trigger on `pull_request` to `main`
2. Add a job `file-size-check` that:
   - Checks out the code
   - Fails if any file in the PR is larger than 1 MB
3. Add a job `branch-name-check` that:
   - Reads the branch name from `${{ github.head_ref }}`
   - Fails if it doesn't follow the pattern `feature/*`, `fix/*`, or `docs/*`
4. Add a job `pr-body-check` that:
   - Reads the PR body: `${{ github.event.pull_request.body }}`
   - Warns (but doesn't fail) if the PR description is empty

**Verify:** Open a PR from a badly named branch — does the check fail?

[pr-lifecycle-check.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/pr-lifecycle-checks.yml)

<img width="1919" height="859" alt="Screenshot 2026-09-21 150943" src="https://github.com/user-attachments/assets/612cd8a6-b317-4484-96f1-da063f077d18" />
<img width="1919" height="863" alt="Screenshot 2026-09-21 151010" src="https://github.com/user-attachments/assets/8159317c-97f4-43b9-9b03-e6ce2d622f17" />


---

### Task 3: Scheduled Workflows (Cron Deep Dive)
Create `.github/workflows/scheduled-tasks.yml`:
1. Add a `schedule` trigger with cron: `'30 2 * * 1'` (every Monday at 2:30 AM UTC)
2. Add **another** cron entry: `'0 */6 * * *'` (every 6 hours)
3. In the job, print which schedule triggered using `${{ github.event.schedule }}`
4. Add a step that acts as a **health check** — curl a URL and check the response code

**Important:** Also add `workflow_dispatch` so you can test it manually without waiting for the schedule.

[scheduled-task.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/scheduled-tasks.yml)

<img width="1919" height="864" alt="Screenshot 2026-09-21 151648" src="https://github.com/user-attachments/assets/4d0ce72d-54d6-4fee-bf7e-fc4bad109785" />

Write in your notes:
- The cron expression for: every weekday at 9 AM IST: `0 3 * * 1-5`
- The cron expression for: first day of every month at midnight: `0 0 1 * *`
- Why GitHub says scheduled workflows may be delayed or skipped on inactive repos
   - Scheduled workflows run on shared runners and only on the default branch.
   - GitHub may delay/skip schedules on inactive repositories to save resources.

---

### Task 4: Path & Branch Filters
Create `.github/workflows/smart-triggers.yml`:
1. Trigger on push but **only** when files in `src/` or `app/` change:
   ```yaml
   on:
     push:
       paths:
         - 'src/**'
         - 'app/**'
   ```
2. Add `paths-ignore` in a second workflow that skips runs when only docs change:
   ```yaml
   paths-ignore:
     - '*.md'
     - 'docs/**'
   ```
3. Add branch filters to only trigger on `main` and `release/*` branches
4. Test it: push a change to a `.md` file — does the workflow skip?

Yes,Workflow skip

[smart-trigger.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/smart-triggers.yml)

<img width="1919" height="882" alt="Screenshot 2026-09-21 151939" src="https://github.com/user-attachments/assets/e318e9a0-2f2f-4515-8ee4-653b7739178a" />


Write in your notes: When would you use `paths` vs `paths-ignore`?

- Use paths when you want the workflow to run only if specific files or folders change.

- Use paths-ignore when the workflow should run for most changes but skip certain files.

---

### Task 5: `workflow_run` — Chain Workflows Together
Create two workflows:
1. `.github/workflows/tests.yml` — runs tests on every push
2. `.github/workflows/deploy-after-tests.yml` — triggers **only after** `tests.yml` completes successfully:
   ```yaml
   on:
     workflow_run:
       workflows: ["Run Tests"]
       types: [completed]
   ```
3. In the deploy workflow, add a conditional:
   - Only proceed if the triggering workflow **succeeded** (`${{ github.event.workflow_run.conclusion == 'success' }}`)
   - Print a warning and exit if it failed

**Verify:** Push a commit — does the test workflow run first, then trigger the deploy workflow?

[test.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/tests.yml)

<img width="1915" height="878" alt="Screenshot 2026-09-21 152225" src="https://github.com/user-attachments/assets/efd8cced-9872-435f-bf4f-c580bae888a5" />

[deploy-after-test.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/deploy-after-tests.yml)

<img width="1919" height="857" alt="Screenshot 2026-09-21 152345" src="https://github.com/user-attachments/assets/240c5a18-731d-4c8e-99ce-2e1d17ed8365" />



---

### Task 6: `repository_dispatch` — External Event Triggers
1. Create `.github/workflows/external-trigger.yml` with trigger `repository_dispatch`
2. Set it to respond to event type: `deploy-request`
3. Print the client payload: `${{ github.event.client_payload.environment }}`
4. Trigger it using `curl` or `gh`:
   ```bash
   gh api repos/<owner>/<repo>/dispatches \
     -f event_type=deploy-request \
     -f client_payload='{"environment":"production"}'
   ```
[external-trigger.yml](https://github.com/tejswini-maingade/GitHub-Action-Practice/blob/main/.github/workflows/external-trigger.yml)

<img width="1094" height="229" alt="Screenshot 2026-09-21 152944" src="https://github.com/user-attachments/assets/c2530118-cd04-4701-b06f-4ba1879e9eaf" />
<img width="1919" height="879" alt="Screenshot 2026-09-21 152933" src="https://github.com/user-attachments/assets/fc223b7b-430a-4b14-84bc-f14ec6b5352a" />


Write in your notes: When would an external system (like a Slack bot or monitoring tool) trigger a pipeline?

When would an external system (like a Slack bot or monitoring tool) trigger a pipeline?

**An external system (like a Slack bot or monitoring tool) would trigger a pipeline when an event outside GitHub needs a workflow to run, such as:**
   - A Slack bot sending a deploy request to start deployment.
   - A monitoring tool detecting an error and triggering a fix workflow.
   - One repository finishing work and notifying another repository to run a workflow.

---

`workflow_call`
   - Makes a workflow reusable, like a function.
   - One workflow calls another directly.
   - Can pass inputs and secrets.
   - `Example`: `deploy.yml` calls `test.yml` before deploying.

`workflow_run`
   - Triggers a workflow after another workflow finishes.
   - Runs automatically based on workflow completion and status.
   - No input passing.
   - `Example`: `deploy.yml` runs only `after tests succeed`.

---

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
