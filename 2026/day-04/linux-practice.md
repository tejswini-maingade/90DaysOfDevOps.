# Day 04 – Linux Practice: Processes and Services

## Process Checks

Command 1:
ps -ef  
- Shows all running processes with CPU and memory usage.
  <img width="1900" height="960" alt="Screenshot 2026-07-27 215806" src="https://github.com/user-attachments/assets/852f0d77-7d7b-4315-b1bf-f0837aa2a337" />


Command 2:
top  
- Live monitoring of system performance.
  <img width="1909" height="955" alt="Screenshot 2026-07-27 220113" src="https://github.com/user-attachments/assets/3288b5f1-c08f-49bb-acae-fc837bc6cdb8" />


Command 3:
pgrep ssh  
- Shows PID of ssh process.
  <img width="1238" height="118" alt="Screenshot 2026-07-27 220221" src="https://github.com/user-attachments/assets/8698434f-a45e-450c-b7bf-950164dfb061" />

---

## Service Checks (ssh service)

Command 4:
systemctl status sshd
- Checked whether ssh service is active or failed.
  <img width="1813" height="650" alt="Screenshot 2026-07-27 220528" src="https://github.com/user-attachments/assets/7fe4a088-415a-4dd0-9112-afa4714c9968" />

Command 5:
systemctl list-units 
- Listed all running services.
  <img width="1913" height="818" alt="Screenshot 2026-07-27 221037" src="https://github.com/user-attachments/assets/2e20bbae-17e2-443d-a84e-9758fa1e6199" />

---

## Log Checks

Command 6:
journalctl -u sshd
- Viewed logs related to ssh service.
  <img width="1908" height="290" alt="Screenshot 2026-07-27 221224" src="https://github.com/user-attachments/assets/fe802362-9608-49be-919b-6a5502528fce" />

Command 7:
tail -n 50 filename
- Display the last 50 lines of the file.
  <img width="1914" height="520" alt="Screenshot 2026-07-27 222244" src="https://github.com/user-attachments/assets/a66dfbd6-ace9-4aa2-b877-f72cb759628f" />

---

## Mini Troubleshooting Flow

Step 1: Check if service is running  
→ systemctl status ssh  

Step 2: If failed, check logs  
→ journalctl -u ssh  

Step 3: If needed, restart service  
→ systemctl restart ssh  

---

## What I Learned

- How to check running processes
- How to inspect service health
- How logs help in debugging
- Linux troubleshooting is mostly about checking processes, services, and logs
