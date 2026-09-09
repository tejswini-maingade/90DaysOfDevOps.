# 🚀Day 40 – Your First GitHub Actions Workflow

## 🎯Task
Today you write your **first GitHub Actions pipeline** and watch it run in the cloud.

This is the moment CI/CD stops being a concept and becomes real.

---

## 🛠️Challenge Tasks

### 🔹Task 1: Set Up
1. Create a new **public** GitHub repository called `github-actions-practice`
2. Clone it locally
3. Create the folder structure: `.github/workflows/`

<img width="1919" height="559" alt="Screenshot 2026-09-09 174502" src="https://github.com/user-attachments/assets/8dce6a37-87dd-489a-bc62-a031605f845c" />


---

### 🔹Task 2: Hello Workflow
Create `.github/workflows/hello.yml` with a workflow that:
1. Triggers on every `push`
2. Has one job called `greet`
3. Runs on `ubuntu-latest`
4. Has two steps:
   - Step 1: Check out the code using `actions/checkout`
   - Step 2: Print `Hello from GitHub Actions!`

Push it. Go to the **Actions** tab on GitHub and watch it run.

**Verify:** Is it green? Click into the job and read every step.

- Yes,it is green

<img width="1919" height="842" alt="Screenshot 2026-09-09 174622" src="https://github.com/user-attachments/assets/db4b98fd-30ab-4a8f-ae6f-0c635f59a54d" />


---

### 🔹Task 3: Understand the Anatomy
Look at your workflow file and write in your notes what each key does:
- `on:`
   - Defines `when the worflow is triggered`
   - It listen for event `push`

- `jobs:`
   - Defines the jobs that the worflow will execute
   - A `workflow` can have one or multiple jobs

- `runs-on:`
   - Specifies the virtual machine(runner) env the job will use.
   - `ubuntu-latest`,`windows-latest`,`macos-latest`

- `steps:`
   - Defines the sequences of actions the job will execute
   - Steps run one after another inside the job.

- `uses:`
   - Tells Github to use a prebuilt action
   - Checkout action to clone the repo.

- `run:`
   - Executes commands directly on the runner

- `name:` (on a step)
   - This is the name of the workflow
   - Give the step a humand readable label in the Actions UI.
---

### 🔹Task 4: Add More Steps
Update `hello.yml` to also:

1. Print the current date and time
```
- name: Print current date and time
  run: date
```

2. Print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
```
- name: Print branch name
  run: echo "Branch name is ${{ github.ref_name }}**
```

3. List the files in the repo
```
- name: List repository files
  run: ls -la
```

4. Print the runner's operating system
```
- name: runner operating system
  run: echo "Runner OS is $RUNNER_OS"
```

Push again — watch the new run.

<img width="1910" height="878" alt="Screenshot 2026-09-09 175845" src="https://github.com/user-attachments/assets/85cdcab9-ef1a-43a5-af6c-6b5de12edbd7" />


---

### 🔹Task 5: Break It On Purpose
1. Add a step that runs a command that will **fail** (e.g., `exit 1` or a misspelled command)
2. Push and observe what happens in the Actions tab
3. Fix it and push again

Write in your notes: What does a failed pipeline look like? How do you read the error?

- Error
<img width="1919" height="465" alt="Screenshot 2026-09-09 175555" src="https://github.com/user-attachments/assets/4124901c-efed-4f9a-9ae7-e176593b704a" />


- Fix

<img width="1910" height="878" alt="Screenshot 2026-09-09 175845" src="https://github.com/user-attachments/assets/560e3abe-7ba6-400e-858f-14193077f6f1" />


---
## 🧠 Key Takeaways

⭐ GitHub Actions automates CI/CD workflows.

⭐ Workflow files are stored inside:

.github/workflows/

⭐ on: → Defines when the workflow runs.

⭐ jobs: → Defines what work needs to be performed.

⭐ runs-on: → Defines where the job runs.

⭐ steps: → Defines the individual tasks.

⭐ uses: → Uses a prebuilt GitHub Action.

⭐ run: → Executes shell commands.

⭐ name: → Gives workflows and steps readable names.

⭐ Every push can trigger a new workflow run when configured with on: push.

⭐ A green 🟢 checkmark means the workflow completed successfully.

⭐ A red ❌ mark means one or more steps failed.

⭐ Logs are essential for troubleshooting failed pipelines.

---

## 🚀 What I Learned

Today I created my first GitHub Actions workflow, triggered it using a Git push, explored the GitHub-hosted runner, added multiple automation steps, intentionally broke the pipeline, analyzed the failure, fixed it, and achieved a successful green pipeline.

CI/CD is no longer just theory — I have now executed my first pipeline! 🚀

---

Happy Learning!

**TrainWithShubham**
