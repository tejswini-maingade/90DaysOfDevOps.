📅 # Day 13 – Linux Volume Management (LVM)

## Task
Learn LVM to manage storage flexibly – create, extend, and mount volumes.

---

📌 ### Task 1: Check Current Storage
Run: `lsblk`, `pvs`, `vgs`, `lvs`, `df -h`
<img width="1914" height="833" alt="Screenshot 2026-08-04 215521" src="https://github.com/user-attachments/assets/3443e10a-f5f9-42e6-a51e-bba2996c1441" />

📌 ### Task 2: Create Physical Volume
```bash
pvcreate /dev/sdb   # or your loop device
pvs
```
<img width="1906" height="451" alt="Screenshot 2026-08-04 222421" src="https://github.com/user-attachments/assets/7c55695d-9c89-47ee-a041-98982e3b5613" />

📌 ### Task 3: Create Volume Group
```bash
vgcreate devops-vg /dev/sdb
vgs
```
<img width="885" height="193" alt="Screenshot 2026-08-04 222530" src="https://github.com/user-attachments/assets/80e79c9f-3c7f-48d4-810f-944991a87d9c" />

📌 ### Task 4: Create Logical Volume
```bash
lvcreate -L 500M -n app-data devops-vg
lvs
```
<img width="1341" height="167" alt="Screenshot 2026-08-04 222611" src="https://github.com/user-attachments/assets/cefe70bf-aef6-4d93-8dbc-f2af5e1ed37b" />

📌 ### Task 5: Format and Mount
```bash
mkfs.ext4 /dev/devops-vg/app-data
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data
df -h /mnt/app-data
```
<img width="1919" height="575" alt="Screenshot 2026-08-04 222840" src="https://github.com/user-attachments/assets/a9d6c9c1-c1cc-4c7a-8c1e-128771beb898" />

📌 ### Task 6: Extend the Volume
```bash
lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data
df -h /mnt/app-data
```
<img width="1633" height="371" alt="Screenshot 2026-08-04 223102" src="https://github.com/user-attachments/assets/bb3f998a-9086-420e-a87a-ef7045a7a140" />

---

🛠️ ## Commands used
```bash
lsblk
pvcreate /dev/loop21
pvs

vgcreate devops-vg /dev/loop21
vgs

lvcreate -L 500M -n app-data devops-vg
lvs

mkfs.ext4 /dev/devops-vg/app-data
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data
df -h /mnt/app-data

lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data
df -h /mnt/app-data

lvdisplay
vgdisplay
pvdisplay

```
---
## What I Learned
- Learned the LVM storage hierarchy: Physical Volume (PV) → Volume Group (VG) → Logical Volume (LV).
- Learned how to convert raw disks into Physical Volumes using `pvcreate`.
- Learned how to combine multiple Physical Volumes into a single Volume Group using `vgcreate`.
- Learned how to create and manage Logical Volumes using `lvcreate`.
- Learned how to format and mount Logical Volumes using the ext4 filesystem.
- Learned the difference between mounting a Logical Volume and mounting a disk directly.
- Learned how to verify storage configuration using `pvs`, `vgs`, `lvs`, and `lsblk`.
- Learned how to inspect detailed LVM information using `pvdisplay`, `vgdisplay`, and `lvdisplay`.
- Learned how to safely unmount storage using `umount`.
- Learned how to extend a Logical Volume dynamically using `lvextend` and resize the filesystem using `resize2fs`.
---
