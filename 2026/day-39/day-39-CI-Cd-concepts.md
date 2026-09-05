# 🚀Day 39 – What is CI/CD?

## 📋Task

CI/CD is a software development practice that helps teams integrate code frequently, test it automatically, and deliver or deploy software reliably.

CI/CD is not a single tool. Tools such as GitHub Actions, Jenkins, GitLab CI/CD, and CircleCI can be used to implement CI/CD practices.

---

# 🧩Task 1: The Problem

Imagine a team of 5 developers working on the same application and manually deploying code to production.

## ⚠️1. What can go wrong?

Several problems can occur:

* Developers may overwrite or conflict with each other's changes.
* Bugs can reach production because testing is done manually.
* A developer may forget an important deployment step.
* Different developers may use different environments or software versions.
* Manual deployments are slow and error-prone.
* Configuration differences can cause production failures.
* Rollbacks can be difficult.
* It becomes difficult to know which code version is running in production.
* Deployments become stressful, especially when done frequently.

## 💡2. What does "It works on my machine" mean?

"It works on my machine" means that an application works correctly in one developer's environment but fails in another environment such as testing or production.

This can happen because of differences in:

* Operating system
* Programming language version
* Libraries and dependencies
* Environment variables
* Configuration
* Database versions
* Installed tools

CI/CD helps reduce this problem by automatically building and testing the application in a consistent environment.

## 🚀3. How many times a day can a team safely deploy manually?

There is no fixed safe number.

However, manual deployments become increasingly risky and inefficient as deployment frequency increases.

A team may manually deploy once or a few times per day, but frequent deployments are better handled through automation.

The goal of CI/CD is to make deployments repeatable, automated, and reliable.

---

# 🔄Task 2: CI vs CD

## 1. Continuous Integration (CI)

Continuous Integration means developers frequently merge or push their code changes into a shared repository.

Each change can automatically trigger a build and automated tests.

CI helps detect bugs, integration problems, and broken builds early.

### Real-world example

A developer pushes code to GitHub. GitHub Actions automatically:

1. Checks out the code.
2. Installs dependencies.
3. Builds the application.
4. Runs unit tests.

If the tests fail, the team knows that the new change has a problem.

---

## 2. Continuous Delivery

Continuous Delivery means keeping software in a deployable state by automatically building, testing, and preparing it for release.

The important difference is that deployment to production usually requires a manual approval or decision.

### Real-world example

A developer pushes code to GitHub.

The pipeline:

1. Builds the application.
2. Runs tests.
3. Creates a Docker image.
4. Deploys the application to staging.
5. Waits for approval before production deployment.

The software is always ready to be deployed, but production deployment is manually approved.

---

## 3. Continuous Deployment

Continuous Deployment goes one step further than Continuous Delivery.

Every change that successfully passes the automated pipeline is automatically deployed to production without a manual approval step.

### Real-world example

A developer pushes code to GitHub.

The pipeline:

1. Builds the application.
2. Runs automated tests.
3. Builds a Docker image.
4. Deploys to staging.
5. Runs validation tests.
6. Automatically deploys to production.

This approach is useful for teams that have strong automated testing, monitoring, and rollback mechanisms.

---

# CI vs Continuous Delivery vs Continuous Deployment

| Practice               | Build | Test | Production Deployment |
| ---------------------- | ----- | ---- | --------------------- |
| Continuous Integration | Yes   | Yes  | No                    |
| Continuous Delivery    | Yes   | Yes  | Manual approval       |
| Continuous Deployment  | Yes   | Yes  | Automatic             |

---

# 🧩Task 3: Pipeline Anatomy

## Trigger

A trigger is an event that starts the pipeline.

Examples:

* Git push
* Pull request
* Scheduled time
* Manual execution
* Release/tag creation

---

## Stage

A stage is a logical phase of a pipeline.

Examples:

* Build
* Test
* Security Scan
* Deploy

A stage can contain one or more jobs.

---

## Job

A job is a unit of work inside a stage.

For example, a Test stage could contain:

* Unit test job
* Integration test job

Jobs may run sequentially or in parallel depending on the pipeline design.

---

## Step

A step is an individual command or action inside a job.

Examples:

```bash
npm install
```

```bash
npm test
```

```bash
docker build -t myapp .
```

---

## Runner

A runner is the machine or execution environment that runs the jobs and steps.

Examples:

* GitHub-hosted runner
* Jenkins agent
* Self-hosted Linux server

---

## Artifact

An artifact is an output produced by a build or job that can be stored and used by later stages.

Examples:

* JAR file
* ZIP package
* Docker image
* Test report
* Build files

---

# 🔀Task 4: CI/CD Pipeline Diagram

Scenario:

A developer pushes code to GitHub. The application is tested, built into a Docker image, and deployed to a staging server.

```text
                  Developer
                      |
                      | git push
                      v
               +--------------+
               |    GitHub    |
               +--------------+
                      |
                      | Trigger
                      v
        +---------------------------+
        |       BUILD STAGE         |
        |---------------------------|
        | Checkout Code             |
        | Install Dependencies      |
        | Build Application         |
        +---------------------------+
                      |
                      v
        +---------------------------+
        |        TEST STAGE         |
        |---------------------------|
        | Unit Tests                |
        | Integration Tests         |
        | Security Checks           |
        +---------------------------+
                      |
                  Tests Pass
                      |
                      v
        +---------------------------+
        |     DOCKER BUILD STAGE    |
        |---------------------------|
        | Docker Build              |
        | Tag Docker Image          |
        | Push Image to Registry    |
        +---------------------------+
                      |
                      v
        +---------------------------+
        |       DEPLOY STAGE        |
        |---------------------------|
        | Pull Docker Image         |
        | Deploy to Staging Server  |
        +---------------------------+
                      |
                      v
              Staging Environment
```

### Simplified Pipeline

```text
Git Push
   |
   v
GitHub
   |
   v
Build
   |
   v
Test
   |
   v
Docker Build
   |
   v
Docker Registry
   |
   v
Staging Server
```

---

# 🌍Task 5: Explore CI/CD in the Wild

## Repository Selected

I explored the Kubernetes open-source repository on GitHub.

Repository:

https://github.com/kubernetes/kubernetes

The repository contains GitHub Actions workflows under:

```text
.github/workflows/
```

One workflow can be selected and analyzed to understand how an open-source project automates its CI/CD activities.

## What triggers the workflow?

The workflow can be triggered by GitHub events such as:

* Push
* Pull request
* Manual workflow execution

The exact trigger depends on the selected workflow YAML file.

## How many jobs does it have?

The number of jobs depends on the selected workflow.

For the workflow I inspected, I identified the jobs defined under the `jobs:` section of the YAML file.

## What does it do?

The workflow automates activities such as:

1. Checking out source code.
2. Setting up the required environment.
3. Running validation or tests.
4. Performing build-related tasks.
5. Reporting the result back to GitHub.

The exact purpose depends on the specific workflow selected.

---

# 💡Key Learnings

## CI/CD is a practice, not a tool

CI/CD describes a software development and delivery approach.

Tools such as:

* GitHub Actions
* Jenkins
* GitLab CI/CD
* CircleCI

can implement CI/CD pipelines.

## Pipeline failure is not necessarily a problem

A failed pipeline can be useful because it prevents bad code from moving to the next stage.

For example:

```text
Developer Push
      |
      v
     Build
      |
      v
     Test
      |
   FAILED
      |
      X
Production deployment stopped
```

The pipeline has successfully detected a problem before it reached production.

---

# 📝Final Summary

CI/CD helps development teams automate the process of building, testing, and delivering software.

The main concepts learned today are:

* Continuous Integration
* Continuous Delivery
* Continuous Deployment
* Trigger
* Stage
* Job
* Step
* Runner
* Artifact

A typical CI/CD flow is:

```text
Code
  |
  v
GitHub
  |
  v
Build
  |
  v
Test
  |
  v
Docker Image
  |
  v
Registry
  |
  v
Staging
  |
  v
Production
```

The main goal of CI/CD is to make software delivery **faster, repeatable, automated, and reliable**.
