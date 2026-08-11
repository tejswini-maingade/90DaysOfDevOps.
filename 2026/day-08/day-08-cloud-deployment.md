# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Part 1: Launch Cloud Instance & SSH Access  
Step 1: Created a Ubuntu EC2 Instance in AWS account  

Step 2: Connect via SSH  
- Setup the security group for SSH connection (Port 22)  
- Access the AWS EC2 instance from local system using Git bash terminal  
  `ssh -i "private-key.pem" username@public-ip/hostname`

-----

## Part 2: Install Docker & Nginx  
Step 1: Update System  
`sudo apt update && sudo apt upgrade -y`

Step 2: Install Nginx
```
sudo apt install nginx
systemctl start nginx
systemctl enable nginx
```

<img width="1919" height="816" alt="Screenshot 2026-07-30 234838" src="https://github.com/user-attachments/assets/b1714345-fbff-45a9-bb50-baa28f9f72d1" />

Step 3: Install docker
```
sudo apt install docker.io
systemctl start dokcer
systemctl enable docker
```
<img width="1708" height="131" alt="Screenshot 2026-07-30 235412" src="https://github.com/user-attachments/assets/c3b9336e-4cb7-4e2f-b715-0234eff688cf" />

---------

## Part 3: Security Group Configuration
- Setup the security group fot http traffic (Port 80)  
- Test Web Access: Open browser and visit: http://<instance-ip>

<img width="1910" height="543" alt="Screenshot 2026-07-31 000711" src="https://github.com/user-attachments/assets/8de59113-d2b9-4727-a2a6-a4f41f55822b" />

------------

## Part 4: Extract Nginx Logs  
Step 1: View Nginx Logs
`journalctl -u nginx`

Step 2: Save Logs to File
`sudo cat /var/log/nginx/access.log > nginx-logs.txt`

Step 3: Download Log File to Your Local Machine  
`scp -i "Mylinux-server.pem" ubuntu@13.232.139.224:/home/ubuntu/nginx-logs.txt ./nginx-logs.txt`

--------------

## Commands Used  
- ssh -i "private-key.pem" username@public-ip/hostname  
- sudo apt update && sudo apt upgrade -y  
- systemctl status <service>  
- journalctl -u <service>  
- scp -i "Mylinux-server.pem" ubuntu@13.232.139.224:/home/ubuntu/nginx-logs.txt ./nginx-logs.txt  

