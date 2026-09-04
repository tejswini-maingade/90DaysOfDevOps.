# 🚀Day 38 – YAML Basics

## 🎯Task
Before writing a single CI/CD pipeline, you need to get comfortable with **YAML** — the language every pipeline is written in.

You will:
- Understand YAML syntax and rules
- Write YAML files by hand
- Validate them

---

## 🔹Challenge Tasks

### 📝Task 1: Key-Value Pairs
Create `person.yaml` that describes yourself with:
- `name`
- `role`
- `experience_years`
- `learning` (a boolean)


---

### 📋Task 2: Lists
Add to `person.yaml`:
- `tools` — a list of 5 DevOps tools you know or are learning
- `hobbies` — a list using the inline format `[item1, item2]`

Write in your notes: What are the two ways to write a list in YAML?

- Using - dash

- Using square brackets [ ] inline format
- 
**Verify:** Run `cat person.yaml` — does it look clean? No tabs?

<img width="1264" height="380" alt="Screenshot 2026-09-04 124402" src="https://github.com/user-attachments/assets/fe2d921b-1f84-456c-bcc8-5a0fe7cf4128" />

---

### 🏗️Task 3: Nested Objects
Create `server.yaml` that describes a server:
- `server` with nested keys: `name`, `ip`, `port`
- `database` with nested keys: `host`, `name`, `credentials` (nested further: `user`, `password`)

**Verify:** Try adding a tab instead of spaces — what happens when you validate it?
- Gives wrong indentation error

<img width="1326" height="347" alt="Screenshot 2026-09-04 124556" src="https://github.com/user-attachments/assets/03a9c058-6fec-4518-8e6e-d94e723dfaa9" />


---

### 📜Task 4: Multi-line Strings
In `server.yaml`, add a `startup_script` field using:
1. The `|` block style (preserves newlines)
2. The `>` fold style (folds into one line)

Write in your notes: When would you use `|` vs `>`?
-  `|` - Use when formatting matters (scripts, commands, exact output) &  `>` - Use when you want cleaner, wrapped text without line breaks

<img width="1301" height="518" alt="Screenshot 2026-09-04 124602" src="https://github.com/user-attachments/assets/52784a74-c8aa-4cf7-82a2-c0f0ef44d1ce" />


---

### ✅Task 5: Validate Your YAML
1. Install `yamllint` or use an online validator
2. Validate both your YAML files
3. Intentionally break the indentation — what error do you get?
4. Fix it and validate again

<img width="1030" height="154" alt="Screenshot 2026-09-04 123533" src="https://github.com/user-attachments/assets/9dcb46fc-d097-4bae-b847-5318e88dae88" />
<img width="1027" height="140" alt="Screenshot 2026-09-04 123521" src="https://github.com/user-attachments/assets/ae66f944-e319-48ba-8aae-ca2f5272b1c2" />

---

### 🔍Task 6: Spot the Difference
Read both blocks and write what's wrong with the second one:

```yaml
# Block 1 - correct
database:
  host: db-server
  name: devopsdb
```

```yaml
# Block 2 - broken
database:
  host: db-server
    name: devopsdb
```
- In Block 2 Wrong indentation for the list item kubernetes


<img width="1129" height="154" alt="Screenshot 2026-09-04 124748" src="https://github.com/user-attachments/assets/ff47ea4c-ca29-4aa5-b158-2c61e79121d4" />

---

Happy Learning!
**TrainWithShubham**
