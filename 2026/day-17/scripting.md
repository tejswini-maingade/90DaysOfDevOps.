# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## 🎯 Objective

Today I practiced Bash scripting concepts that are commonly used in DevOps automation.

### Topics Covered

- `for` loops
- `while` loops
- Command-line arguments
- User input
- Package installation
- Root user validation
- Error handling
- Bash arrays

---

### Task 1: For Loop
1. Create `for_loop.sh` that:
   - Loops through a list of 5 fruits and prints each one
2. Create `count.sh` that:
   - Prints numbers 1 to 10 using a for loop

## Loops through a list of 5 fruits and prints each one

<img width="967" height="287" alt="Screenshot 2026-08-09 184214" src="https://github.com/user-attachments/assets/7d780be2-0921-4454-bb8f-3d76d961d68c" />
<img width="1919" height="349" alt="Screenshot 2026-08-09 184006" src="https://github.com/user-attachments/assets/b4c54323-ec89-425b-8b7d-57900e6d6bee" />


## Prints numbers 1 to 10 using a for loop

<img width="945" height="428" alt="Screenshot 2026-08-09 190053" src="https://github.com/user-attachments/assets/df57063a-b9d3-4415-9077-8a66160fe0fe" />
<img width="492" height="271" alt="Screenshot 2026-08-09 185815" src="https://github.com/user-attachments/assets/ee54f2e0-7e3e-4ed9-b8e9-038bab7b61f8" />


---

### Task 2: While Loop
1. Create `countdown.sh` that:
   - Takes a number from the user
   - Counts down to 0 using a while loop
   - Prints "Done!" at the end
     
<img width="787" height="556" alt="Screenshot 2026-08-09 190702" src="https://github.com/user-attachments/assets/09b0c6bc-f34c-4d20-9e15-753ddd4de0f3" />
<img width="649" height="359" alt="Screenshot 2026-08-09 190445" src="https://github.com/user-attachments/assets/01019700-5adc-4b22-bf31-7de208e0de22" />


---

### Task 3: Command-Line Arguments
1. Create `greet.sh` that:
   - Accepts a name as `$1`
   - Prints `Hello, <name>!`
   - If no argument is passed, prints "Usage: ./greet.sh <name>"

<img width="763" height="167" alt="Screenshot 2026-08-09 191300" src="https://github.com/user-attachments/assets/0a426349-30dc-40fc-882d-6a15cf0ae3e3" />
<img width="667" height="245" alt="Screenshot 2026-08-09 191211" src="https://github.com/user-attachments/assets/6f1063e6-651b-4a4b-bd38-af4271b218c9" />


2. Create `args_demo.sh` that:
   - Prints total number of arguments (`$#`)
   - Prints all arguments (`$@`)
   - Prints the script name (`$0`)
     
<img width="833" height="226" alt="Screenshot 2026-08-09 191559" src="https://github.com/user-attachments/assets/a5564676-1c77-43ba-a671-c95b4eea4377" />
<img width="539" height="168" alt="Screenshot 2026-08-09 191517" src="https://github.com/user-attachments/assets/3c5d8b90-5a54-482a-861d-1f42b9242154" />


---

### Task 4: Install Packages via Script
1. Create `install_packages.sh` that:
   - Defines a list of packages: `nginx`, `curl`, `wget`
   - Loops through the list
   - Checks if each package is installed (use `dpkg -s` or `rpm -q`)
   - Installs it if missing, skips if already present
   - Prints status for each package

> Run as root: `sudo -i` or `sudo su`

<img width="932" height="246" alt="Screenshot 2026-08-09 192424" src="https://github.com/user-attachments/assets/58e6dbeb-9609-4a8b-8e6a-c612529e84a2" />
<img width="762" height="368" alt="Screenshot 2026-08-09 192324" src="https://github.com/user-attachments/assets/47e238ad-2a7a-46d9-949c-33b8fbe129b8" />

---
### Task 5: Error Handling
1. Create `safe_script.sh` that:
   - Uses `set -e` at the top (exit on error)
   - Tries to create a directory `/tmp/devops-test`
   - Tries to navigate into it
   - Creates a file inside
   - Uses `||` operator to print an error if any step fails

Example:
```bash
mkdir /tmp/devops-test || echo "Directory already exists"
```

2. Modify your `install_packages.sh` to check if the script is being run as root — exit with a message if not.
   
<img width="1304" height="424" alt="Screenshot 2026-08-09 201111" src="https://github.com/user-attachments/assets/48a7a7e1-ea0c-41a8-a2de-eeb84e40c75d" />
<img width="876" height="378" alt="Screenshot 2026-08-09 201121" src="https://github.com/user-attachments/assets/aefe30fa-f6a7-4e6c-8c83-87692150ae19" />


---
## What I Learned

* Used for loops to iterate over lists and number ranges
* Used while loops for countdown logic with user input
* Handled command-line arguments using $1, $#, $@, $0
* Added usage messages for missing arguments
* Took user input using read
* Automated package installation (nginx, curl, wget)
* Checked package status using dpkg -s
* Added root user validation using $EUID
* Implemented error handling with set -e and || (Or)
* Created safe scripts to avoid failures and overwrites
* Issue Faced & Lesson Learned: Used commas in a Bash array, causing the loop to fail, Learned that Bash arrays must be space-separated, not comma-separated

---

