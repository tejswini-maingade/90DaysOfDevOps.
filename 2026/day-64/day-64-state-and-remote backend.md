# Day 64 — Terraform State Management and Remote Backends

**Challenge:** TerraWeek | 90DaysOfDevOps  
**Cloud Provider:** AWS  
**Region:** ap-south-1

## 1. Objective

The objective of this task was to understand Terraform state management, configure a remote backend using Amazon S3, explore state locking, import existing resources, perform state operations, and detect and resolve infrastructure drift.

## 2. Local State vs. Remote State Architecture

### Local State

```text
Developer Machine
       |
       v
Terraform Configuration (.tf)
       |
       v
Local terraform.tfstate
       |
       v
AWS Infrastructure
```

In local state management, Terraform stores the state file on the local machine. This can be risky because the file may be lost, damaged, or unavailable to other team members.

### Remote State

```text
Developer / CI-CD Pipeline
          |
          v
   Terraform Commands
          |
          v
   Amazon S3 Backend
   - Remote State File
   - Encryption
   - Versioning
          |
          v
  DynamoDB Lock Table
          |
          v
    AWS Infrastructure
```

Remote state allows team members to work with shared infrastructure state. S3 versioning helps recover earlier state versions, while the configured locking mechanism helps prevent concurrent state modifications.

## 3. Task 1 — Inspect Current State

Commands used:

```bash
terraform show
terraform state list
terraform state show aws_instance.<RESOURCE_NAME>
terraform state show aws_vpc.<RESOURCE_NAME>
```

### Observations

- `terraform show` displays the current state in a readable format.
- `terraform state list` displays the resource addresses tracked by Terraform.
- `terraform state show` displays detailed attributes of a specific resource.
- The EC2 state can include attributes such as instance ID, AMI, instance type, availability zone, IP addresses, subnet ID, security groups, and tags.

**Number of resources tracked:** [Add your actual resource count]

**State serial number:** The serial number represents the revision of the Terraform state. It increases as state changes are recorded and helps Terraform identify newer state versions.

**Screenshot:** Add a screenshot of your `terraform state list` or `terraform show` output here.

## 4. Task 2 — Configure S3 Remote Backend

### Backend Infrastructure

The backend infrastructure consists of an S3 bucket for storing Terraform state and a DynamoDB table for state locking.

Example backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "REPLACE_WITH_YOUR_BUCKET_NAME"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "REPLACE_WITH_YOUR_LOCK_TABLE"
    encrypt        = true
  }
}
```

Replace the placeholder values with your actual AWS resource names. Terraform backend blocks do not accept ordinary input variables.

### Migration Commands

```bash
terraform init -migrate-state
terraform plan
```

During initialization, Terraform asks whether to migrate the existing local state to the remote backend. After verifying the backend configuration, select `yes` to copy the state.

### Verification

- Confirm that the state object exists in the S3 bucket.
- Verify that S3 bucket versioning is enabled.
- Run `terraform plan` to check whether the configuration and infrastructure are synchronized.

**Result:** [Add your actual migration and plan results]

**Screenshot:** Add a screenshot showing `dev/terraform.tfstate` in your S3 bucket. Do not share the contents of the state file publicly.

## 5. Task 3 — Test State Locking

Commands:

```bash
terraform apply
```

While the first Terraform operation is holding the lock, try running the following command in another terminal:

```bash
terraform plan
```

### Observation

Terraform should report that the state is locked if the first operation is actively holding a lock and the backend locking mechanism is configured correctly.

**Actual error message:** [Paste your observed lock error here]

### Why Is State Locking Important?

State locking prevents multiple Terraform operations from modifying the same state simultaneously. Without locking, concurrent operations can cause state inconsistencies and infrastructure management problems.

**Important:** Use `terraform force-unlock <LOCK_ID>` only after confirming that the original operation has stopped and the lock is genuinely stale.

**Screenshot:** Add your actual lock-error screenshot here.

## 6. Task 4 — Import an Existing AWS Resource

Terraform can manage resources that were created manually in AWS.

Example configuration:

```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "REPLACE_WITH_YOUR_EXISTING_BUCKET_NAME"
}
```

Import the existing bucket:

```bash
terraform import aws_s3_bucket.imported REPLACE_WITH_YOUR_EXISTING_BUCKET_NAME
```

Verify the resource:

```bash
terraform state list
terraform plan
```

### Difference Between Import and Creating a Resource

- **Import:** Associates an existing AWS resource with a Terraform resource address in the state.
- **Create:** Terraform provisions a new resource based on the configuration.

Importing does not automatically generate a complete configuration or guarantee that the plan will show no changes. The configuration must match the existing resource.

**Result:** [Add your actual import and plan output]

**Screenshot:** Add the successful import output here.

## 7. Task 5 — State Surgery

### Rename a Resource

```bash
terraform state mv aws_s3_bucket.imported aws_s3_bucket.logs_bucket
```

Update the Terraform configuration to use the new resource name and run:

```bash
terraform plan
```

### Remove a Resource from State

```bash
terraform state rm aws_s3_bucket.logs_bucket
```

This removes the resource from Terraform state without deleting the actual AWS resource.

Re-import it when required:

```bash
terraform import aws_s3_bucket.logs_bucket REPLACE_WITH_YOUR_EXISTING_BUCKET_NAME
```

### When Should These Commands Be Used?

- **`terraform state mv`:** Used when renaming a resource address or moving a resource to another address without recreating the real infrastructure.
- **`terraform state rm`:** Used when Terraform should stop tracking a resource without destroying it in AWS.
- **`terraform import`:** Used to bring an existing resource under Terraform state management.

Always review the plan after state operations. Removing a resource from state while leaving its resource block in the configuration can cause Terraform to propose creating another resource.

## 8. Task 6 — Simulate and Fix State Drift

### What Is State Drift?

State drift occurs when someone changes infrastructure outside Terraform, such as through the AWS Console or AWS CLI.

### Steps

1. Apply the Terraform configuration so the infrastructure is synchronized.
2. Change the EC2 instance's Name tag manually in the AWS Console to `ManuallyChanged`.
3. Run:

```bash
terraform plan
```

4. Review the detected differences.
5. Restore the desired configuration by running:

```bash
terraform apply
terraform plan
```

### Expected Result

Terraform should restore the EC2 tag to the value defined in the configuration. After reconciliation, the next plan should report `No changes` if all managed resources are synchronized.

**Actual change made:** [Describe the change you performed]

**Actual result:** [Add the final plan output]

**Screenshots:** Add the drift detection plan and final verification screenshot here.

### How Teams Prevent Drift in Production

1. Restrict direct AWS Console changes using least-privilege IAM permissions.
2. Manage infrastructure changes through reviewed Terraform code and CI/CD pipelines.
3. Run regular Terraform plans and drift-detection checks.
4. Store state remotely with controlled access and appropriate versioning.
5. Review plans before applying changes.
6. Document emergency changes and update the Terraform configuration when necessary.

## 9. Important Terraform Commands

| Command | Purpose |
|---|---|
| `terraform show` | Displays state or saved plan details |
| `terraform state list` | Lists tracked resources |
| `terraform state show ADDRESS` | Shows resource attributes |
| `terraform init -migrate-state` | Migrates existing state to a new backend |
| `terraform plan` | Compares configuration with infrastructure |
| `terraform import ADDRESS ID` | Imports an existing resource into state |
| `terraform state mv SOURCE DESTINATION` | Changes a resource address in state |
| `terraform state rm ADDRESS` | Removes a resource from state without destroying it |
| `terraform apply -refresh-only` | Updates state based on observed infrastructure |
| `terraform force-unlock LOCK_ID` | Removes a confirmed stale lock |

## 10. Key Learnings

- Terraform state is essential for tracking real infrastructure.
- Remote backends improve collaboration and reduce the risk of losing local state.
- S3 versioning provides a way to recover earlier state versions.
- State locking helps prevent concurrent operations from corrupting shared state.
- Importing existing resources makes infrastructure management through Terraform possible.
- State surgery changes Terraform's resource tracking without inherently creating or deleting AWS resources.
- Drift detection helps identify and reconcile differences between configuration and actual infrastructure.

## 11. Completion Checklist

- [ ] Inspected Terraform state and recorded the resource count.
- [ ] Configured the S3 remote backend.
- [ ] Verified S3 state storage and bucket versioning.
- [ ] Tested state locking and captured the actual error.
- [ ] Imported an existing AWS resource.
- [ ] Practiced `terraform state mv` and `terraform state rm`.
- [ ] Simulated and reconciled state drift.
- [ ] Added screenshots and actual command outputs.
- [ ] Verified that no credentials, private keys, or sensitive state files are included.

## 12. GitHub Submission

Save the documentation as:

`2026/day-64/day-64-state-management.md`

From the repository root, run:

```bash
git add 2026/day-64/day-64-state-management.md
git commit -m "docs: add Day 64 Terraform state management"
git push
```

Before pushing, verify that `.terraform/`, local Terraform state files, credentials, and private keys are excluded from Git.

## Learn in Public

Mastered Terraform state management concepts today as part of #90DaysOfDevOps!

Learned about remote state with Amazon S3, state locking, importing existing AWS resources, state surgery, and detecting and reconciling infrastructure drift.

Every day is an opportunity to learn, build, and improve my DevOps skills.

#90DaysOfDevOps #TerraWeek #DevOpsKaJosh #TrainWithShubham
