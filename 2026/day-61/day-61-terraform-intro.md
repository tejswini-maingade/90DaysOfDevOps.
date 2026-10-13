# 🌱 TerraWeek Day 1 — Introduction to IaC & Terraform Basics

![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![Day 1](https://img.shields.io/badge/TerraWeek-Day%2001-2EA44F)
![Status](https://img.shields.io/badge/Status-Completed-success)

Welcome to **Day 1 of the TerraWeek Challenge!**

Today, I explored the fundamentals of Infrastructure as Code (IaC), learned how Terraform works, installed the Terraform CLI, and provisioned my first local resources using the `local` and `random` providers — without requiring AWS credentials or creating paid cloud infrastructure.

## 🎯 Learning Objectives

- Understand Infrastructure as Code (IaC) and its benefits.
- Learn what Terraform is and why it is widely used in DevOps.
- Compare Terraform with OpenTofu, Pulumi, AWS CloudFormation, and Ansible.
- Install and verify the Terraform CLI.
- Understand six essential Terraform concepts.
- Execute the complete Terraform workflow: `init`, `fmt`, `validate`, `plan`, `apply`, and `destroy`.
- Generate a local file using Terraform.
- Understand the purpose of `.terraform.lock.hcl`.

## 📚 Task 1 — Introduction to IaC and Terraform

### What is Infrastructure as Code (IaC)?

Infrastructure as Code is the practice of defining and managing infrastructure through configuration files instead of creating resources manually through graphical interfaces.

**Benefits of IaC:**

- Automation and repeatability
- Consistent infrastructure environments
- Version control and collaboration
- Reduced manual errors
- Easier infrastructure maintenance and recovery

### What is Terraform?

Terraform is an Infrastructure as Code tool developed by HashiCorp. It uses a declarative approach, allowing us to describe the desired infrastructure state in configuration files written in HashiCorp Configuration Language (HCL).

Terraform compares the configuration with its state and the observed infrastructure to determine which changes are needed.

**Why Terraform?**

- Supports multiple cloud platforms and services through providers.
- Uses declarative configuration.
- Provides a plan-before-apply workflow.
- Supports reusable modules.
- Integrates with Git and CI/CD pipelines.

### Terraform vs Other Tools

| Tool | Key Difference |
|---|---|
| Terraform | Declarative IaC with a broad provider ecosystem. |
| OpenTofu | Open-source IaC tool originating as a fork of Terraform. |
| Pulumi | Defines infrastructure using general-purpose programming languages. |
| AWS CloudFormation | AWS-native infrastructure provisioning service. |
| Ansible | Commonly automates configuration management and server setup; it can also provision infrastructure. |

## 🧠 Task 2 — Terraform Installation

Installed Terraform in my development environment and verified the CLI.

```bash
terraform version
terraform -help
```

The version command confirms the installed Terraform version, while the help command lists available Terraform commands.

**VS Code:** Installed the HashiCorp Terraform extension for syntax highlighting and language support.

Official resources:

- [Terraform Installation Guide](https://developer.hashicorp.com/terraform/install)
- [HashiCorp Terraform VS Code Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

> Record your actual Terraform version and environment details in your notes.

## 🔑 Task 3 — Six Essential Terraform Terminologies

| Terminology | Explanation | Example |
|---|---|---|
| Provider | A plugin that connects Terraform to a platform or service. | `random` provider generates random values. |
| Resource | An object Terraform manages. | `local_file` creates a file on the local system. |
| State | Records Terraform's knowledge of managed resources. | `terraform.tfstate` stores resource state. |
| Plan | Previews proposed infrastructure changes. | `terraform plan` shows resources to be created. |
| HCL | Configuration language used to write Terraform files. | `resource "local_file" "greeting" { ... }` |
| Module | A reusable collection of Terraform configuration. | A networking module can define a VPC and subnets. |

## 🛠️ Task 4 — My First Terraform Configuration

For the practical exercise, I used the starter configuration in the `example/` directory. It uses the `local` and `random` providers to demonstrate Terraform resource management without creating cloud infrastructure.

### Step 1: Initialize Terraform

```bash
terraform init
```

Initializes the working directory and downloads the required provider plugins.

### Step 2: Format the configuration

```bash
terraform fmt
```

Formats Terraform files according to standard formatting conventions.

### Step 3: Validate the configuration

```bash
terraform validate
```

Checks the configuration for syntax and consistency issues.

### Step 4: Preview the changes

```bash
terraform plan
```

Displays the changes Terraform proposes to make before applying them.

### Step 5: Apply the configuration

```bash
terraform apply
```

Reviewed the proposed changes and entered `yes` when prompted to create the resources.

### Step 6: Verify the generated file

```bash
cat greeting.txt
```

Inspected the generated greeting file created by the Terraform configuration.

### Step 7: Destroy the resources

```bash
terraform destroy
```

Reviewed the cleanup plan and entered `yes` to remove the resources managed by this example.

> **Note:** Run these commands from the `example/` directory containing the `.tf` configuration files. The exact resource counts and output depend on the supplied starter code.

<img width="1568" height="1016" alt="Screenshot 2026-10-13 132925" src="https://github.com/user-attachments/assets/0ca5783c-43a5-4369-b523-b0a52101fa9e" />
<img width="1619" height="1016" alt="Screenshot 2026-10-13 133009" src="https://github.com/user-attachments/assets/916dbfad-d4b7-44cd-b3e0-5e9b5959ce2f" />
<img width="838" height="65" alt="Screenshot 2026-10-13 133104" src="https://github.com/user-attachments/assets/4b0b1cde-6462-4d54-aba1-7ec5fdc3633a" />
<img width="1895" height="917" alt="Screenshot 2026-10-13 133124" src="https://github.com/user-attachments/assets/eda449cb-2644-4a37-a8c1-705f652983e0" />


## 🔄 Terraform Workflow

The core Terraform workflow is:

**Write → Init → Format → Validate → Plan → Apply → Verify → Destroy**

| Command | Purpose |
|---|---|
| `terraform init` | Initializes the working directory and providers. |
| `terraform fmt` | Formats configuration files. |
| `terraform validate` | Validates configuration syntax and consistency. |
| `terraform plan` | Previews proposed changes. |
| `terraform apply` | Applies the approved changes. |
| `terraform destroy` | Removes managed resources. |

## 🍫 Bonus Learnings

### 1. `.terraform.lock.hcl`

The dependency lock file records the selected provider versions and checksums. It helps maintain consistent and verified provider installations across environments.

### 2. Terraform CLI Autocomplete

```bash
terraform -install-autocomplete
```

Enables command completion in supported shell environments when configured successfully.

### 3. OpenTofu

OpenTofu is an open-source alternative that shares Terraform's declarative IaC approach and HCL syntax. Compatibility and feature differences should be checked before switching between tools.

## 💡 Key Takeaways

- IaC makes infrastructure management repeatable and easier to maintain.
- Terraform describes desired infrastructure declaratively.
- Providers allow Terraform to interact with different platforms.
- `terraform plan` helps review changes before applying them.
- Terraform state is important for tracking managed resources.
- `terraform destroy` helps clean up resources created for testing.
- Local providers make it possible to practise Terraform fundamentals without provisioning cloud infrastructure.

Replace these example filenames with your actual screenshot filenames.

```

The exact files inside `example/` depend on the starter configuration. Keep the supplied Terraform filenames and commit the provider lock file.

## 📖 References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform CLI Commands](https://developer.hashicorp.com/terraform/cli/commands)
- [Terraform Registry](https://registry.terraform.io/)
- [OpenTofu Documentation](https://opentofu.org/docs/)
- [TerraWeek Challenge Repository](https://github.com/tejswini-maingade/TerraWeek)
- [Terraform for DevOps — Companion Repository](https://github.com/LondheShubham153/terraform-for-devops)

---

## 🚀 Conclusion

Day 1 of TerraWeek helped me build a strong foundation in Infrastructure as Code and Terraform. I successfully practised the Terraform workflow using local resources and learned how to initialize, validate, plan, apply, and destroy resources.

This is the first step in my journey toward mastering Terraform and applying Infrastructure as Code principles to real-world DevOps and cloud projects.

**Next up:** Continue the TerraWeek Challenge and build on these fundamentals!

#TerraWeek #TerraWeekChallenge #TrainWithShubham #Terraform #InfrastructureAsCode #IaC #DevOps #CloudComputing #100DaysOfDevOps
