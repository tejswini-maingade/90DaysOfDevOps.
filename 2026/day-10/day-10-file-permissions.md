# 🚀 Day-10: File Permissions & File Operations.

## 📁 Files Created
- Create empty file

    `touch devops.txt`

- Create file with content

    `echo "These are my DevOps notes" > notes.txt`

- Create script using vim

    `vim script.sh`
    
- Inside vim, add:

    `echo "Hello DevOps"`
    
    Save and exit (:wq)

- Verify files

    `ls -l`

    <img width="1910" height="273" alt="Screenshot 2026-08-01 150316" src="https://github.com/user-attachments/assets/d0fccef5-1f14-459d-884c-d086b0502f78" />


- Read notes.txt

    `cat notes.txt`

   <img width="583" height="103" alt="Screenshot 2026-08-01 150341" src="https://github.com/user-attachments/assets/f58d3f8b-d24e-40cc-b2d6-35c1854ab766" />


- Open script.sh in read-only mode

    `vim -R script.sh`
  
  <img width="1919" height="740" alt="Screenshot 2026-08-01 150434" src="https://github.com/user-attachments/assets/1285df9a-55b0-44e5-8d8c-a87db461d8b2" />

- Display first 5 lines of /etc/passwd

    `head -n 5 /etc/passwd`

  <img width="699" height="133" alt="Screenshot 2026-08-01 150545" src="https://github.com/user-attachments/assets/3ce940bf-0a3d-4490-aedb-41ba14f997f1" />

- Display last 5 lines of /etc/passwd

    `tail -n 5 /etc/passwd`
  <img width="726" height="157" alt="Screenshot 2026-08-01 150551" src="https://github.com/user-attachments/assets/7b0aa599-4433-4305-bd51-7a0fb59ac21e" />


## 🔐 Permission Changes
- Format: rwxrwxrwx → owner, group, others

- Values: r=4, w=2, x=1

- Example output:

    `ls -l devops.txt notes.txt script.sh`

  <img width="813" height="121" alt="Screenshot 2026-08-01 150634" src="https://github.com/user-attachments/assets/2c3507c3-7139-458d-8251-e298464f497b" />

    Answer:

    - devops.txt → -rw-rw-r-- → owner can read/write, group can read/write, others can read.

    - notes.txt → -rw-rw-r-- → same as above.

    - script.sh → -rw-rw-r-- → same as above.

- Make script executable

    `chmod +x script.sh`

    `./script.sh   # Runs "Hello DevOps"`

- Set devops.txt to read-only

    `chmod a-w devops.txt`

- Set notes.txt to 640 (rw for owner, r for group, none for others)

    `chmod 640 notes.txt`

- Create directory with 755 permissions

    `mkdir project`

    `chmod 755 project`

- Verify after each change

    `ls -l`

<img width="1919" height="320" alt="Screenshot 2026-08-01 151043" src="https://github.com/user-attachments/assets/93319589-82ab-4767-831b-7bb07220581e" />

- Try writing to read-only file

    `echo "new text" >> devops.txt`

     Error: "Permission denied"

    <img width="698" height="68" alt="Screenshot 2026-08-01 151121" src="https://github.com/user-attachments/assets/bc2d89cd-1221-41c5-bfac-0abca7f487b0" />

- Remove execute permission and try running script

    `chmod -x script.sh`

    `./script.sh`
    
    Error: "Permission denied"
  
    <img width="613" height="114" alt="Screenshot 2026-08-01 151227" src="https://github.com/user-attachments/assets/bb1bab6b-f7b1-471f-b5db-a29e3eef9f2d" />

## 💡 What I Learned

1. *File Operations* : I practiced creating, editing, and reading files using *touch*, *echo*, *cat*, and *vim*, and explored system files with *head* and *tail*.

2. *Permissions Fundamentals* : I understood the *rwxrwxrwx* format, numeric values (r=4, w=2, x=1), and how ownership affects read/write/execute access.

3. *Permission Management* : I modified permissions with *chmod* (symbolic and numeric), tested restrictions, and observed how Linux enforces security through error messages like “Permission denied.” 
