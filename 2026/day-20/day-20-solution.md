# 🚀 Day 20 – Bash Scripting Challenge: Log Analyzer and Report Generator

## 🎯 Task

You are a system administrator responsible for managing a network of servers. Every day, a log file is generated on each server containing important system events and error messages. Your job is to analyze these log files, identify specific events, and generate a summary report.

Write a Bash script (`log_analyzer.sh`) that automates the process of analyzing log files and generating a daily summary report.

---

## 📦 Expected Output

* 🐚 A Bash script: `log_analyzer.sh`
* 📄 A generated summary report: `log_report_<date>.txt`
* 📝 A markdown file: `day-20-solution.md` documenting your approach

---

## 🧩 Challenge Tasks

### 🔹 Task 1: Input and Validation

Your script should:

1. 📥 Accept the path to a log file as a command-line argument
2. ❌ Exit with a clear error message if no argument is provided
3. ⚠️ Exit with a clear error message if the file doesn't exist

### 📤 Output

To accomplish Task 1, you'll need to use special variables like `$1` (the first argument) and "test" operators like `-f` (to check if a file exists).

### 🧠 Key Concepts

| Component              | Logic                                                                                                                                          |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `$#`                   | 🔢 A built-in variable that counts the number of arguments. If it's 0, the user forgot the input.                                              |
| `$0`                   | 📌 This refers to the name of the script itself, useful for showing the "Usage" message.                                                       |
| `[ ! -f "$LOG_FILE" ]` | 🔍 The `-f` flag specifically checks if the path points to a file (rather than a directory). The `!` means "if NOT a file."                    |
| `exit 1`               | 🚫 In Linux, an exit code of 0 means success, while any non-zero number indicates an error. This helps other programs know your script failed. |

<img width="670" height="196" alt="Screenshot 2026-08-11 134014" src="https://github.com/user-attachments/assets/d94291de-7d76-4ded-968a-97c681aaf3ed" />

---

### 🔹 Task 2: Error Count

1. 🔎 Count the total number of lines containing the keyword `ERROR` or `Failed`
2. 🖥️ Print the total error count to the console

### 📄 Create a New File

```bash
vim error_count.sh
```

### 🧪 Create a Sample Log

Run this command in your terminal to create a dummy log file with some errors in it:

```bash
echo -e "INFO: System started\nERROR: Database connection failed\nDEBUG: Loading assets\nFailed: Authentication timeout\nINFO: User logged in" > sample.log
```

### 📂 Real Log File

If your real log file is somewhere else (like `/var/log/syslog`), you need to provide the full path:

```bash
./error_count.sh /var/log/syslog
```

### 🔍 Verify the File Exists

Before running your script again, you can double-check the file is there by typing:

```bash
ls -l sample.log
```

### ✅ Final Test

Once you've created the file using the echo command above, run your script again:

```bash
./error_count.sh sample.log
```

<img width="1919" height="376" alt="Screenshot 2026-08-11 134313" src="https://github.com/user-attachments/assets/14206b88-6962-4b34-b8fb-68c22080817f" />

---

### 🔹 Task 3: Critical Events

1. 🔎 Search for lines containing the keyword `CRITICAL`
2. 📌 Print those lines along with their line number

### 📤 Example Output

```text
--- Critical Events ---
Line 84: 2025-07-29 10:15:23 CRITICAL Disk space below threshold
Line 217: 2025-07-29 14:32:01 CRITICAL Database connection lost
```

### 📄 Create `critical.sh`

Add a critical event:

```bash
echo "CRITICAL: Power supply failure on line 4" >> sample.log
```

### ▶️ Run the Script

```bash
./critical.sh sample.log
```

<img width="1329" height="274" alt="Screenshot 2026-08-11 134518" src="https://github.com/user-attachments/assets/adeb1bc5-090d-4694-b779-19e1fa5ecf6c" />

---

### 🔹 Task 4: Top Error Messages

1. 🔎 Extract all lines containing `ERROR`
2. 📊 Identify the **top 5 most common** error messages
3. 📈 Display them with their occurrence count, sorted in descending order

<img width="746" height="183" alt="Screenshot 2026-08-11 134658" src="https://github.com/user-attachments/assets/9cc17294-db19-4af4-8c9b-19d8674bd1b9" />

---

### 🔹 Task 5: Summary Report

Generate a summary report to a text file named `log_report_<date>.txt` (e.g., `log_report_2026-02-11.txt`).

The report should include:

1. 📅 Date of analysis
2. 📄 Log file name
3. 📊 Total lines processed
4. ❌ Total error count
5. 🔝 Top 5 error messages with their occurrence count
6. 🚨 List of critical events with line numbers
   
<img width="1333" height="511" alt="Screenshot 2026-08-11 134843" src="https://github.com/user-attachments/assets/27b536eb-a86c-4c43-8c25-64537bfde6a9" />

---

### 🔹 Task 6 (Optional): Archive Processed Logs

Add a feature to:

1. 📁 Create an `archive/` directory if it doesn't exist
2. 📦 Move the processed log file into `archive/` after analysis
3. ✅ Print a confirmation message

---

<img width="1333" height="511" alt="Screenshot 2026-08-11 134843" src="https://github.com/user-attachments/assets/da0d8972-adfb-434b-a2cd-45c378fbf9f9" />

---

## 📚 What I Learned

* 🧩 How to break a larger automation problem into smaller focused scripts (input validation, error counting, top errors, critical events) and then combine them into one complete solution.
* 🛠️ How to use core Linux tools (`grep`, `awk`, `sort`, `uniq`, `sed`, `wc`) together to extract meaningful insights from raw log data.
* 🛡️ The importance of defensive scripting — validating inputs and handling missing files before processing.
* 📄 How to generate structured summary reports with dynamic filenames using `date`.
* 📦 How to automate post-processing tasks like archiving analyzed logs to keep directories clean and organized.
