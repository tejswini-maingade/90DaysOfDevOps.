# Day 42 – Runners: GitHub-Hosted & Self-Hosted

## Task
Every job needs a machine to run on. Today you understand **runners** — GitHub's hosted ones and how to set up your own self-hosted runner on a real server.

---

## Challenge Tasks

### Task 1: GitHub-Hosted Runners
1. Create a workflow with 3 jobs, each on a different OS:
   - `ubuntu-latest`
   - `windows-latest`
   - `macos-latest`
2. In each job, print:
   - The OS name
   - The runner's hostname
   - The current user running the job
3. Watch all 3 run in parallel

<img width="1919" height="835" alt="Screenshot 2026-09-10 143231" src="https://github.com/user-attachments/assets/7460bde7-b5cf-46c5-9512-05c9423a1557" />
<img width="1919" height="780" alt="Screenshot 2026-09-10 143247" src="https://github.com/user-attachments/assets/8558f819-4a4b-444a-8cae-2bc4244f2009" />
<img width="1919" height="708" alt="Screenshot 2026-09-10 143258" src="https://github.com/user-attachments/assets/fec03f19-c39d-4808-9154-7b01387a232c" />
<img width="1919" height="785" alt="Screenshot 2026-09-10 143309" src="https://github.com/user-attachments/assets/7b299890-7a9e-40da-a98a-97e7ec4f95a3" />



**What is a GitHub-hosted runner? Who manages it?**

    What is a GitHub-hosted runner? Who manages it?

    - `Github-hosted` runner is a temporary virtual machine provided by GitHub that runs GitHub Actions workflows.

    - `GitHub-hosted` runners are managed by GitHub on Microsoft Azure infrastructure.
    
    - Responsible for:
        - Creating the virtual machine
        - Installing software
        -  Maintaining security
        - Deleting the machine after the job completes.
        
---

### Task 2: Explore What's Pre-installed
1. On the `ubuntu-latest` runner, run a step that prints:
   - Docker version
   - Python version
   - Node version
   - Git version
2. Look up the GitHub docs for the full list of pre-installed software on `ubuntu-latest`

<img width="1919" height="840" alt="Screenshot 2026-09-10 143825" src="https://github.com/user-attachments/assets/e476975c-34c7-4e1f-a66c-9c35db780fa9" />


**Write in your notes: Why does it matter that runners come with tools pre-installed?**

- It matters because pre-installed tools make workflows faster and easier to configure. Developers can run builds and tests immediately without installing common tools like Docker, Python, Node.js, and Git, while GitHub maintains and updates the environment.

---

### Task 3: Set Up a Self-Hosted Runner
1. Go to your GitHub repo → Settings → Actions → Runners → **New self-hosted runner**
2. Choose Linux as the OS
3. Follow the instructions to download and configure the runner on:
   - Your local machine, OR
   - A cloud VM (EC2, Utho, or any VPS)
4. Start the runner — verify it shows as **Idle** in GitHub

**Verify:** Your runner appears in the Runners list with a green dot.

<img width="1918" height="755" alt="Screenshot 2026-09-18 162009" src="https://github.com/user-attachments/assets/a58e80de-ce29-4dc3-93b7-2197cd111659" />
<img width="1919" height="159" alt="Screenshot 2026-09-18 162038" src="https://github.com/user-attachments/assets/7d889ec9-20e9-43cd-8469-43cccc2e7f43" />
<img width="1919" height="551" alt="Screenshot 2026-09-18 162247" src="https://github.com/user-attachments/assets/f563304a-56f1-4be8-9806-17ccedea756b" />


---

### Task 4: Use Your Self-Hosted Runner
1. Create `.github/workflows/self-hosted.yml`
2. Set `runs-on: self-hosted`
3. Add steps that:
   - Print the hostname of the machine (it should be YOUR machine/VM)
   - Print the working directory
   - Create a file and verify it exists on your machine after the run
4. Trigger it and watch it run on your own hardware

**Verify:** Check your machine — is the file there?
- Yes,file is there

<img width="1919" height="518" alt="Screenshot 2026-09-18 162646" src="https://github.com/user-attachments/assets/d5b87089-e9f2-42f3-8a8f-993b3d9c01ec" />

  
---

### Task 5: Labels
1. Add a **label** to your self-hosted runner (e.g., `my-linux-runner`)
2. Update your workflow to use `runs-on: [self-hosted, my-linux-runner]`
3. Trigger it — does it still pick up the job? - **Yes**

Write in your notes: Why are labels useful when you have multiple self-hosted runners?
- Labels are useful when you have multiple self-hosted runners because they help GitHub Actions choose the correct runner for a specific job

<img width="1919" height="491" alt="Screenshot 2026-09-18 162917" src="https://github.com/user-attachments/assets/2b993cc8-8ad4-4d1c-88b0-e1901c4170a5" />


---

### Task 6: GitHub-Hosted vs Self-Hosted
Fill this in your notes:

| | GitHub-Hosted | Self-Hosted |
|---|---|---|
| Who manages it? | GitHub | We manage it |
| Cost | Free 2000 mins (per month, public repos unlimited) | As per our own infrastructure usage |
| Pre-installed tools | Yes (common languages, build tools, Docker, etc.) | No (we install and maintain ourselves) |
| Good for | Small independent jobs, quick CI/CD setup | Production workloads, specialized environments |
| Security concern | Controlled by GitHub —so must be handled carefully | Our responsibility — we must secure the machine, patch OS/tools, and protect secrets |

---

**TrainWithShubham**
