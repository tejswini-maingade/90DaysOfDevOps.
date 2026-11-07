# Day 70 -- Variables, Facts, Conditionals and Loops

## Task
Your playbooks work, but they are static -- same packages, same config, same behavior on every server. Real infrastructure is not like that. Web servers need Nginx, app servers need Node.js, production gets more memory than dev. Today you make your playbooks smart.

Variables, facts, conditionals, and loops turn a rigid script into flexible automation that adapts to each host, each group, and each environment.

---

## Challenge Tasks

### Task 1: Variables in Playbooks
Create `variables-demo.yml`:

```yaml
---
- name: Variable demo
  hosts: all
  become: true

  vars:
    app_name: terraweek-app
    app_port: 8080
    app_dir: "/opt/{{ app_name }}"
    packages:
      - git
      - curl
      - wget

  tasks:
    - name: Print app details
      debug:
        msg: "Deploying {{ app_name }} on port {{ app_port }} to {{ app_dir }}"

    - name: Create application directory
      file:
        path: "{{ app_dir }}"
        state: directory
        mode: '0755'

    - name: Install required packages
      yum:
        name: "{{ packages }}"
        state: present
```

Run it and verify the variables resolve correctly.

<img width="1072" height="618" alt="image" src="https://github.com/user-attachments/assets/a9bf92b0-6b7d-4df8-9dd6-09e82f9fbb40" />

Now, override a variable from the command line:
```bash
ansible-playbook variables-demo.yml -e "app_name=my-custom-app app_port=9090"
```

**Verify:** Does the CLI variable override the playbook variable?

- Yes

<img width="1095" height="564" alt="image" src="https://github.com/user-attachments/assets/13c2f07d-7fe1-455f-b7ca-802e41a8ba98" />

---

### Task 2: group_vars and host_vars
Variables should not live inside playbooks. Move them to dedicated files.

Create this structure:
```
ansible-practice/
  inventory.ini
  ansible.cfg
  group_vars/
    all.yml
    web.yml
    db.yml
  host_vars/
    web-server.yml
  playbooks/
    site.yml
```

**`group_vars/all.yml`** -- applies to every host:
```yaml
---
ntp_server: pool.ntp.org
app_env: development
common_packages:
  - vim
  - htop
  - tree
```

**`group_vars/web.yml`** -- applies only to the web group:
```yaml
---
http_port: 80
max_connections: 1000
web_packages:
  - nginx
```

**`group_vars/db.yml`** -- applies only to the db group:
```yaml
---
db_port: 3306
db_packages:
  - mysql-server
```

**`host_vars/web-server.yml`** -- applies only to this specific host:
```yaml
---
max_connections: 2000
custom_message: "This is the primary web server"
```

Write a playbook `site.yml` that uses these variables:
```yaml
---
- name: Apply common config
  hosts: all
  become: true
  tasks:
    - name: Install common packages
      yum:
        name: "{{ common_packages }}"
        state: present
    - name: Show environment
      debug:
        msg: "Environment: {{ app_env }}"

- name: Configure web servers
  hosts: web
  become: true
  tasks:
    - name: Show web config
      debug:
        msg: "HTTP port: {{ http_port }}, Max connections: {{ max_connections }}"
    - name: Show host-specific message
      debug:
        msg: "{{ custom_message }}"
```

<img width="1109" height="804" alt="image" src="https://github.com/user-attachments/assets/b84ec42b-f4f7-466b-9e83-ca275a4a6343" />

Run it and observe which variables apply to which hosts.

- `Observations:`
  - `app_env` applied to all hosts
  - `http_port` only web group
  - `db_port` only db group
  - `custom_message` only web-server
  - `max_connections` came from group_vars
  
**Document:** What is the variable precedence? (hint: host_vars > group_vars > playbook vars, and `-e` overrides everything)

 - `host_vars` > `group_vars` > `playbook vars`, and `-e` overrides everything

---

### Task 3: Ansible Facts -- Gathering System Information
Ansible automatically collects "facts" about each managed node -- OS, IP, memory, CPU, disks, and hundreds more.

1. **See all facts for a host:**
```bash
ansible web-server -m setup
```

<img width="762" height="770" alt="image" src="https://github.com/user-attachments/assets/70b41489-aa9e-4757-9010-af71e2bbb0dc" />

2. **Filter specific facts:**
```bash
ansible web-server -m setup -a "filter=ansible_os_family"
ansible web-server -m setup -a "filter=ansible_distribution*"
ansible web-server -m setup -a "filter=ansible_memtotal_mb"
ansible web-server -m setup -a "filter=ansible_default_ipv4"
```

<img width="877" height="819" alt="image" src="https://github.com/user-attachments/assets/ec3c38de-2386-4793-a9be-a2432aab90c7" />

3. **Use facts in a playbook** -- create `facts-demo.yml`:
```yaml
---
- name: Facts demo
  hosts: all
  tasks:
    - name: Show OS info
      debug:
        msg: >
          Hostname: {{ ansible_hostname }},
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }},
          RAM: {{ ansible_memtotal_mb }}MB,
          IP: {{ ansible_default_ipv4.address }}

    - name: Show all network interfaces
      debug:
        var: ansible_interfaces
```

Run it and observe the facts printed for each host.

<img width="883" height="767" alt="image" src="https://github.com/user-attachments/assets/04f2ece4-3502-4e1b-bcc6-6f7e32cc16cb" />

**Document:** Name five facts you would use in real playbooks and why.

- `ansible_hostname` to identify the host and use it in configs/logs
- `ansible_default_ipv4.address` to get the primary IP for networking tasks
- `ansible_os_family` to apply OS-specific tasks (e.g., RedHat vs Debian)
- `ansible_distribution` to handle version-specific package installs
- `ansible_mounts` determine available disk space dynamically

---

### Task 4: Conditionals with when
Tasks should not always run on every host. Use `when` to control execution.

Create `conditional-demo.yml`:

```yaml
---
- name: Conditional tasks demo
  hosts: all
  become: true

  tasks:
    - name: Install Nginx (only on web servers)
      yum:
        name: nginx
        state: present
      when: "'web' in group_names"

    - name: Install MySQL (only on db servers)
      yum:
        name: mysql-server
        state: present
      when: "'db' in group_names"

    - name: Show warning on low memory hosts
      debug:
        msg: "WARNING: This host has less than 1GB RAM"
      when: ansible_memtotal_mb < 1024

    - name: Run only on Amazon Linux
      debug:
        msg: "This is an Amazon Linux machine"
      when: ansible_distribution == "Amazon"

    - name: Run only on Ubuntu
      debug:
        msg: "This is an Ubuntu machine"
      when: ansible_distribution == "Ubuntu"

    - name: Run only in production
      debug:
        msg: "Production settings applied"
      when: app_env == "production"

    - name: Multiple conditions (AND)
      debug:
        msg: "Web server with enough memory"
      when:
        - "'web' in group_names"
        - ansible_memtotal_mb >= 512

    - name: OR condition
      debug:
        msg: "Either web or app server"
      when: "'web' in group_names or 'app' in group_names"
```

Run it and observe which tasks are skipped on which hosts.

- Observation

  - `Nginx installation` – skipped on db-server and app-server; runs on web-server.
  - `MariaDB installation` – skipped on web-server and app-server; runs on db-server.
  - `Low memory warning` – runs on all hosts.
  - `Amazon Linux check` – runs on all hosts.
  - `Ubuntu check` – skipped on all hosts.
  - `Production check` – skipped on all hosts.
  - `Multiple conditions (AND)` – runs only on web-server.
  -  `OR condition` – runs on web-server and app-server; skipped on db-server.

  <img width="836" height="762" alt="image" src="https://github.com/user-attachments/assets/a5fc1c25-6b2d-421c-b596-ac0f40cd25bc" />

**Verify:** Are tasks correctly skipping on hosts that don't match the condition?

- Yes
   
---

### Task 5: Loops
Create `loops-demo.yml`:

```yaml
---
- name: Loops demo
  hosts: all
  become: true

  vars:
    users:
      - name: deploy
        groups: wheel
      - name: monitor
        groups: wheel
      - name: appuser
        groups: users

    directories:
      - /opt/app/logs
      - /opt/app/config
      - /opt/app/data
      - /opt/app/tmp

  tasks:
    - name: Create multiple users
      user:
        name: "{{ item.name }}"
        groups: "{{ item.groups }}"
        state: present
      loop: "{{ users }}"

    - name: Create multiple directories
      file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
      loop: "{{ directories }}"

    - name: Install multiple packages
      yum:
        name: "{{ item }}"
        state: present
      loop:
        - git
        - curl
        - unzip
        - jq

    - name: Print each user created
      debug:
        msg: "Created user {{ item.name }} in group {{ item.groups }}"
      loop: "{{ users }}"
```

Run it and observe the loop output -- each iteration is shown separately.

<img width="767" height="749" alt="image" src="https://github.com/user-attachments/assets/77452070-6958-46dc-a612-121c723aa285" />

<img width="865" height="660" alt="image" src="https://github.com/user-attachments/assets/9cd9dd57-a8eb-44a4-b6b7-d63a2cd4473e" />

**Document:** What is the difference between `loop` and the older `with_items`? (hint: `loop` is the modern recommended syntax)

- `with_items` is the old looping syntax

  ```
  - name: Install packages
  yum:
    name: "{{ item }}"
    state: present
  with_items:
    - nginx
    - git
  ```

- `loop` is the modern recommended syntax

```
- name: Install packages
  yum:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
```

---

### Task 6: Register, Debug, and Combine Everything
Build a real-world playbook `server-report.yml` that combines variables, facts, conditionals, and register:

```yaml
---
- name: Server Health Report
  hosts: all

  tasks:
    - name: Check disk space
      command: df -h /
      register: disk_result

    - name: Check memory
      command: free -m
      register: memory_result

    - name: Check running services
      shell: systemctl list-units --type=service --state=running | head -20
      register: services_result

    - name: Generate report
      debug:
        msg:
          - "========== {{ inventory_hostname }} =========="
          - "OS: {{ ansible_distribution }} {{ ansible_distribution_version }}"
          - "IP: {{ ansible_default_ipv4.address }}"
          - "RAM: {{ ansible_memtotal_mb }}MB"
          - "Disk: {{ disk_result.stdout_lines[1] }}"
          - "Running services (first 20): {{ services_result.stdout_lines | length }}"

    - name: Flag if disk is critically low
      debug:
        msg: "ALERT: Check disk space on {{ inventory_hostname }}"
      when: "'9[0-9]%' in disk_result.stdout or '100%' in disk_result.stdout"

    - name: Save report to file
      copy:
        content: |
          Server: {{ inventory_hostname }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          IP: {{ ansible_default_ipv4.address }}
          RAM: {{ ansible_memtotal_mb }}MB
          Disk: {{ disk_result.stdout }}
          Checked at: {{ ansible_date_time.iso8601 }}
        dest: "/tmp/server-report-{{ inventory_hostname }}.txt"
      become: true
```

Run it and verify the report file is created on each server.

<img width="936" height="767" alt="image" src="https://github.com/user-attachments/assets/35f07afc-a9fd-47d4-a5f4-543c035c6838" />

**Verify:** SSH into a server and read `/tmp/server-report-*.txt`. Does it contain accurate information?

- Yes

<img width="1120" height="753" alt="image" src="https://github.com/user-attachments/assets/0d7c28ce-129b-4812-a085-6f371eb846a5" />
<img width="1097" height="450" alt="image" src="https://github.com/user-attachments/assets/691aefa5-5f69-4613-9b6e-67319b7d2bb7" />

- Variable precedence (simplified, low to high):
   
  - role defaults -> group_vars/all -> group_vars/ -> host_vars/ -> playbook vars -> task vars -> extra vars (`-e`)

- How variable precedence works with examples from your test

  - `host_vars` > `group_vars` > `group_vars/all`

- `group_vars`/ and `host_vars`/ directory structure
<img width="655" height="353" alt="image" src="https://github.com/user-attachments/assets/726acddc-18f3-4f15-a5ac-ad6347685cea" />

---

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

Happy Learning!
**TrainWithShubham**
