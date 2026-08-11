# 🌐 Day 15 – Networking Concepts: DNS, IP Addressing, Subnets & Ports

## 🎯 Objective

Today, I learned some of the most important networking concepts that every DevOps Engineer should understand. Modern applications communicate over networks, so knowing how DNS, IP addresses, subnetting, and ports work is essential for deploying, troubleshooting, and maintaining applications.

In this hands-on session, I explored how a domain name is converted into an IP address, how devices communicate using IP addresses, why subnetting is important, and how ports allow multiple services to run on the same server.

---

# 📌 Task 1 – DNS (Domain Name System)

## What is DNS?

The **Domain Name System (DNS)** is often called the **phonebook of the Internet**.

Humans find it easier to remember names like:

```
google.com
github.com
amazon.com
```

But computers communicate using **IP addresses**, such as:

```
142.250.183.110
```

DNS translates a domain name into its corresponding IP address so that your browser knows where to connect.

---

## 🌍 What Happens When You Type `google.com` in a Browser?

1. You enter **google.com** in your browser.
2. The browser asks a **DNS server** for Google's IP address.
3. The DNS server replies with Google's IP address.
4. The browser creates a **TCP connection** to that IP address.
5. The browser sends an **HTTP/HTTPS request**.
6. Google's web server processes the request.
7. The server returns the webpage to your browser.
8. The browser displays the webpage.

### 📖 Real-Life Example

Think of DNS like your mobile phone contacts.

* You search for **"Tej"**
* Your phone finds **Tej's phone number**
* Then the call is made

Similarly,

* You type **google.com**
* DNS finds Google's IP address
* Your browser connects to that IP

---

# 📚 Common DNS Record Types

### A Record

Maps a domain name to an **IPv4 address**.

Example:

```
google.com → 142.250.183.110
```

---

### AAAA Record

Maps a domain name to an **IPv6 address**.

Used when the website supports IPv6 networking.

---

### CNAME Record

Creates an alias for another domain.

Example:

```
www.example.com
          ↓
example.com
```

Instead of maintaining two separate records, both names point to the same destination.

---

### MX Record

Specifies which mail server receives emails for a domain.

Example:

```
gmail.com
```

Its MX record points to Google's mail servers.

---

### NS Record

Specifies the authoritative DNS servers responsible for managing DNS records of a domain.

---

# 🖥️ Commands Used

```bash
dig google.com
```

or

```bash
nslookup google.com
```

### 🔍 Observation

From the output, I observed:

* The A Record (IPv4 Address)
* The TTL (Time To Live)

TTL tells DNS servers how long they can cache the DNS response before requesting it again.

---

# 📌 Task 2 – IP Addressing

## What is an IP Address?

An **IP Address (Internet Protocol Address)** is a unique address assigned to every device connected to a network.

It allows devices to identify and communicate with each other.

Example:

```
192.168.1.10
```

Just as every house has a postal address, every device on a network has an IP address.

---

## IPv4

IPv4 uses **32 bits** and consists of four numbers separated by dots.

Example:

```
192.168.1.10
```

---

## Public IP vs Private IP

### 🌍 Public IP

A Public IP is accessible over the Internet.

It is assigned by your Internet Service Provider (ISP).

Example:

```
34.125.90.10
```

Anyone on the Internet can communicate with this IP (if allowed by firewall rules).

---

### 🏠 Private IP

Private IP addresses are used only within internal networks.

They cannot be accessed directly from the Internet.

Example:

```
172.31.17.152
```

AWS EC2 instances usually receive private IP addresses inside a VPC.

---

## Private IP Address Ranges

```
10.0.0.0/8

172.16.0.0 – 172.31.255.255

192.168.0.0/16
```

These ranges are reserved for private networks.

---

## Command Used

```bash
ip addr show
```

or

```bash
hostname -I
```

### 🔍 Observation

My EC2 instance is using a **private IP address**, which is used for communication within the AWS Virtual Private Cloud (VPC).

---

# 📌 Task 3 – CIDR & Subnetting

## What is CIDR?

CIDR stands for:

**Classless Inter-Domain Routing**

CIDR determines:

* Network size
* Number of available IP addresses
* Network and host portions of an IP address

---

## What Does `/24` Mean?

Example:

```
192.168.1.0/24
```

This means:

* First **24 bits** represent the **network**
* Remaining **8 bits** represent **host addresses**

A `/24` network contains:

* Total IPs → **256**
* Usable Host IPs → **254**

(Two addresses are reserved: one for the network address and one for the broadcast address.)

---

## Why Do We Use Subnetting?

Subnetting divides one large network into smaller, more manageable networks.

### Benefits

* 🔒 Improves security by isolating different parts of the network.
* ⚡ Reduces unnecessary broadcast traffic, improving performance.
* 🛠️ Makes networks easier to manage and troubleshoot.
* 📈 Allows efficient use of available IP addresses.

In cloud platforms like AWS, subnetting helps separate public and private resources securely.

---

## CIDR Reference Table

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
| ---- | --------------- | --------: | -----------: |
| /24  | 255.255.255.0   |       256 |          254 |
| /16  | 255.255.0.0     |    65,536 |       65,534 |
| /28  | 255.255.255.240 |        16 |           14 |

---

# 📌 Task 4 – Ports

## What is a Port?

A **Port** is a logical communication endpoint used by applications.

A server has one IP address but can run many applications simultaneously because each application listens on a different port.

Think of:

* IP Address = Apartment Building
* Port = Apartment Number

The IP identifies the building, while the port identifies the specific application inside it.

---

## Commonly Used Ports

|  Port | Service | Purpose                 |
| ----: | ------- | ----------------------- |
|    22 | SSH     | Secure remote login     |
|    53 | DNS     | Domain name resolution  |
|    80 | HTTP    | Unencrypted web traffic |
|   443 | HTTPS   | Secure web traffic      |
|  3306 | MySQL   | MySQL Database          |
|  6379 | Redis   | Redis Cache             |
| 27017 | MongoDB | MongoDB Database        |

---

## Command Used

```bash
ss -tulpn
```

### 🔍 Observation

This command displays:

* Listening ports
* Running services
* Protocol (TCP/UDP)
* Process IDs
* Application names

I observed services listening on ports such as SSH (22) and other active system services.

---

# 📌 Task 5 – Putting Everything Together

## What Happens When We Run

```bash
curl http://myapp.com:8080
```

The request follows these steps:

1. DNS resolves **myapp.com** into an IP address.
2. A TCP connection is established with the server.
3. The request is sent to **port 8080**.
4. The application running on port 8080 receives the request.
5. The application processes the request.
6. The server sends the response back.
7. `curl` displays the response.

This demonstrates how DNS, IP addresses, TCP, ports, and applications work together.

---

# 🛠️ Troubleshooting Scenario

## Problem

My application cannot connect to the database at:

```
10.0.1.50:3306
```

## Steps I Would Check

✅ Is the database server reachable?

```bash
ping 10.0.1.50
```

---

✅ Is MySQL listening on port **3306**?

```bash
ss -tulpn
```

---

✅ Is the MySQL service running?

```bash
systemctl status mysqld
```

or

```bash
systemctl status mysql
```

---

✅ Is port **3306** open?

```bash
nc -zv 10.0.1.50 3306
```

---

✅ Is the firewall or cloud Security Group blocking traffic?

Check firewall rules or AWS Security Groups to ensure port **3306** is allowed between the application and the database.

---

✅ If using a hostname instead of an IP address, is DNS resolving correctly?

```bash
nslookup database.example.com
```

or

```bash
dig database.example.com
```

---

# 💻 Commands Practiced

```bash
hostname -I
ip addr show
dig google.com
nslookup google.com
ss -tulpn
curl -I https://google.com
```

---

# 📚 What I Learned

* DNS translates human-readable domain names into IP addresses.
* Every device on a network uses an IP address for communication.
* Public IPs are accessible over the internet, while private IPs are used within internal networks.
* CIDR notation defines network size and available host addresses.
* Subnetting improves security, performance, and efficient IP management.
* Ports enable multiple applications to run simultaneously on the same server.
* Tools like `dig`, `nslookup`, `ip`, `ss`, and `curl` are essential for diagnosing networking issues.

---

# 🚀 Why This Matters for DevOps

Almost every DevOps task involves networking. Whether deploying applications, configuring cloud infrastructure, setting up Kubernetes clusters, or troubleshooting production issues, a solid understanding of networking is essential.

These concepts help quickly identify and resolve issues such as:

* 🌐 Website not loading
* 🔍 DNS resolution failures
* 🔒 Firewall or Security Group blocking traffic
* 🛢️ Database connection failures
* 🚪 Services listening on incorrect ports
* ☁️ Cloud networking and VPC configuration issues

A strong networking foundation enables faster troubleshooting, smoother deployments, and more reliable production systems, making it one of the most valuable skills for any DevOps Engineer.
