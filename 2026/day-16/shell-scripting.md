# 🐚 Day 16 – Shell Scripting Basics

## 90 Days of DevOps – Day 16

### 🎯 Objective

Today I started my journey with Shell Scripting and learned the basic building blocks required to automate tasks in Linux.

### I practiced:

- Understanding the Shebang (#!/bin/bash)
- Creating and executing Bash scripts
- Using variables
- Printing output using echo
- Taking user input using read
- Using if, elif, and else
- Performing numeric comparisons
- Checking whether a file exists
- Checking Linux service status using systemctl
- Redirecting command output

Shell scripting is an important DevOps skill because it helps automate repetitive Linux administration and operational tasks.

### 📚 What is Shell Scripting?

A shell script is a text file containing a sequence of commands that are executed by a shell.

Instead of manually running multiple commands:

```bash
mkdir backup
cp file.txt backup/
ls -l backup/
```

We can put them into a script:
```bash
#!/bin/bash

mkdir backup
cp file.txt backup/
ls -l backup/
```

Then execute the script:

```bash
chmod 755 backup.sh
./backup.sh
```

### Why Shell Scripting is useful in DevOps

* Shell scripts are commonly used for:

- Server administration
- Application deployment
- Log management
- Backup automation
- Service monitoring
- File operations
- System health checks
- CI/CD automation
- Infrastructure troubleshooting

---

## Challenge Tasks

### 🧩 Task 1: Your First Script
1. Create a file `hello.sh`
2. Add the shebang line `#!/bin/bash` at the top
3. Print `Hello, DevOps!` using `echo`
4. Make it executable and run it

```bash
chmod 755 hello.sh
./hello.sh
```

<img width="749" height="233" alt="Screenshot 2026-08-08 112913" src="https://github.com/user-attachments/assets/55b51426-b3c5-4abe-9228-18f50036cd1e" />


**Document:** What happens if you remove the shebang line?

* What happens if you remove the shebang line?
 - The script runs after removing shebang line :
    - `./hello.sh` - The kernel checks for a shebang to identify the interpreter ("Shebang" tells the comuter to use Bash to read the script and "Echo" command tells it to print the text. If no shebang is found, the script is executed using the current shell.
    - `bash hello.sh` - The script is explicitly executed by the Bash shell,independent of the presence of a shebang.
    - `sh hello.sh` - The script is executed using the `sh shell`,which may differ in behavior from bash
---

### 🧩 Task 2: Variables
1. Create `variables.sh` with:
   - A variable for your `NAME`
   - A variable for your `ROLE` (e.g., "DevOps Engineer")
   - Print: `Hello, I am <NAME> and I am a <ROLE>`
2. Try using single quotes vs double quotes — what's the difference?
* Using double quote `" "` - Allow **variable expansion**
* Using single quote `' '` - Treat every character exactly as written
  
<img width="873" height="186" alt="Screenshot 2026-08-08 114611" src="https://github.com/user-attachments/assets/a69caa03-ce22-4550-a054-9bd6c80f1ba1" />
<img width="647" height="276" alt="Screenshot 2026-08-08 114519" src="https://github.com/user-attachments/assets/3603a7a0-ab55-462f-a24b-569bc770d6f5" />

---

### 🧩 Task 3: User Input with read
1. Create `greet.sh` that:
   - Asks the user for their name using `read`
   - Asks for their favourite tool
   - Prints: `Hello <name>, your Fav DevOps tool name is <tool>`
   - 
<img width="1036" height="268" alt="Screenshot 2026-08-08 120101" src="https://github.com/user-attachments/assets/af28a9c7-3efb-43c8-bff2-381285cdf373" />
<img width="1919" height="541" alt="Screenshot 2026-08-08 115919" src="https://github.com/user-attachments/assets/a47353d1-4592-4bda-b219-8ff934e36cf7" />

---

### 🧩 Task 4: If-Else Conditions
1. Create `check_number.sh` that:
   - Takes a number using `read`
   - Prints whether it is **positive**, **negative**, or **zero**
     
<img width="829" height="124" alt="Screenshot 2026-08-08 123011" src="https://github.com/user-attachments/assets/5a17923a-ee1d-4919-b3a8-13b5fd7181d5" />
<img width="1919" height="589" alt="Screenshot 2026-08-08 122837" src="https://github.com/user-attachments/assets/26c40f16-ce59-4419-9fc9-704597bed353" />

---

2. Create `file_check.sh` that:
   - Asks for a filename
   - Checks if the file **exists** using `-f`
   - Prints appropriate message
   - 
<img width="952" height="304" alt="Screenshot 2026-08-08 123654" src="https://github.com/user-attachments/assets/a9883278-dd41-4677-b6cd-b6e1a1ed712b" />
<img width="849" height="514" alt="Screenshot 2026-08-08 123528" src="https://github.com/user-attachments/assets/30520038-1ec2-455e-9571-92473fcd1749" />

---

### 🧩 Task 5: Combine It All
Create `server_check.sh` that:
1. Stores a service name in a variable (e.g., `nginx`, `sshd`)
2. Asks the user: "Do you want to check the status? (y/n)"
3. If `y` — runs `systemctl status <service>` and prints whether it's **active** or **not**
4. If `n` — prints "Skipped."

<img width="951" height="342" alt="Screenshot 2026-08-08 124943" src="https://github.com/user-attachments/assets/5e139e5a-6592-4c50-a63e-030e362afc7b" />
<img width="1329" height="515" alt="Screenshot 2026-08-08 124632" src="https://github.com/user-attachments/assets/a152da93-1029-4ef6-97ef-0f1b478dd801" />

---

## 🧠 Hints
- Shebang: `#!/bin/bash` tells the system which interpreter to use
- Variables: `NAME="Shubham"` (no spaces around `=`)
- Read: `read -p "Enter name: " NAME`
- If syntax: `if [ condition ]; then ... elif ... else ... fi`
- File check: `if [ -f filename ]; then`

---

## 📌 What I Have learned:
* How to write and execute Bash shell scripts using the shebang (#!/bin/bash),variables,and user input with read.
* How variable assignment works in Bash,including accessing variables with $ and understanding single vs double quotes.
* How to control script flow using conditional statements (if, elif, else) and test operators (-f, -gt, -lt).
* How to check file existence and numeric conditions inside shell scripts.
* How to suppress command output using redirection (> /dev/null ).
* How to use systemctl is-active to programmatically check whether a service is running instead of relying on verbose status output.
