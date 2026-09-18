# Day 43 – Jobs, Steps, Env Vars & Conditionals

## Task
Today you learn how to **control the flow** of your pipeline — multi-job workflows, passing data between jobs, environment variables, and running steps only when certain conditions are met.

---

## Challenge Tasks

### Task 1: Multi-Job Workflow
Create `.github/workflows/multi-job.yml` with 3 jobs:
- `build` — prints "Building the app"
- `test` — prints "Running tests"
- `deploy` — prints "Deploying"

Make `test` run only **after** `build` succeeds.
Make `deploy` run only **after** `test` succeeds.

**Verify:** Check the workflow graph in the Actions tab — does it show the dependency chain?

- Yes It show the dependency chain

<img width="1919" height="875" alt="Screenshot 2026-09-18 171115" src="https://github.com/user-attachments/assets/f16e9d44-dd37-4b73-9434-061ace5e8954" />


- `needs` : tells gitHub actions which job must finish before another job can start.

[ Build ] ──► [ Test ] ──► [ Deploy ]

---

### Task 2: Environment Variables
In a new workflow, use environment variables at 3 levels:
1. **Workflow level** — `APP_NAME: myapp`
2. **Job level** — `ENVIRONMENT: staging`
3. **Step level** — `VERSION: 1.0.0`

Print all three in a single step and verify each is accessible.

Then use a **GitHub context variable** — print the commit SHA and the actor (who triggered the run).

<img width="1919" height="881" alt="Screenshot 2026-09-18 171034" src="https://github.com/user-attachments/assets/bddbd7ec-bc4d-4d23-8455-a6fd3bdb4927" />


---

### Task 3: Job Outputs
1. Create a job that **sets an output** — e.g., today's date as a string
2. Create a second job that **reads that output** and prints it
3. Pass the value using `outputs:` and `needs.<job>.outputs.<name>`

<img width="1919" height="872" alt="Screenshot 2026-09-18 171247" src="https://github.com/user-attachments/assets/5cab4b47-a2b9-4e98-a400-7bc68bc979eb" />
<img width="1919" height="803" alt="Screenshot 2026-09-18 171311" src="https://github.com/user-attachments/assets/da63a15b-d65b-4fde-a494-39ab2966ae26" />


Write in your notes: 

**Why would you pass outputs between jobs?**

- Each job runs separately, so Job 2 cannot see what Job 1 created.
- Outputs are used to pass that result from Job 1 to Job 2.
- Example:
  
- Job 1 – Build Docker image
    - This job builds the image and creates a tag for example:myapp:1.0.0

- Job 2 – Push image to registry
    - This job must know which image tag was created so it can push the correct image.

- Job 3 – Deploy the app
    - The deployment job also needs the same tag myapp:1.0.0 to deploy that exact image.

- Why pass outputs?
    - The tag created in Job 1 is passed as an output so the other jobs know exactly which Docker image to use.

---

### Task 4: Conditionals
In a workflow, add:
1. A step that only runs when the branch is `main`
2. A step that only runs when the previous step **failed**
3. A job that only runs on **push** events, not on pull requests
4. A step with `continue-on-error: true` — what does this do?

<img width="1919" height="880" alt="Screenshot 2026-09-18 171517" src="https://github.com/user-attachments/assets/742fd457-0214-4869-83bc-ff429402d21f" />
<img width="1919" height="842" alt="Screenshot 2026-09-18 171529" src="https://github.com/user-attachments/assets/9fb48879-ce5f-44e2-9586-0394544fb578" />


---

### Task 5: Putting It Together
Create `.github/workflows/smart-pipeline.yml` that:
1. Triggers on push to any branch
2. Has a `lint` job and a `test` job running in parallel
3. Has a `summary` job that runs after both, prints whether it's a `main` branch push or a feature branch push, and prints the commit message

<img width="1919" height="878" alt="Screenshot 2026-09-18 171650" src="https://github.com/user-attachments/assets/4c9c2e52-1ff5-4344-8d18-373befd3da4f" />
<img width="1917" height="791" alt="Screenshot 2026-09-18 171706" src="https://github.com/user-attachments/assets/f8553dad-b1fd-4a28-b010-2e21d3da551c" />
<img width="1919" height="838" alt="Screenshot 2026-09-18 171720" src="https://github.com/user-attachments/assets/da435169-ebfe-4d67-9afa-16c7e34d06f0" />


---

## Key Takeaways

| Concept              | Purpose                                                 |
| -------------------- | ------------------------------------------------------- |
| `needs:`             | Create job dependencies                                 |
| `env:`               | Define environment variables at workflow/job/step level |
| `outputs:`           | Pass data between jobs                                  |
| `if:`                | Run steps/jobs conditionally                            |
| `continue-on-error:` | Allow steps to fail without stopping the job            |
| GitHub Context       | Access workflow metadata (SHA, actor, ref, etc.)        |

---

## Learn in Public
Share the dependency chain diagram from your multi-job workflow on LinkedIn.

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
