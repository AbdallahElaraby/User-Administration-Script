# 🧑‍💻 Linux User & Group Management Script

A Bash-based interactive CLI tool for system administrators to manage users and groups using the `whiptail` dialog utility.

> Developed by **Abdallah Elaraby**  
> 📍 ITI – Information Technology Institute  
> 🛠️ Version: 1.0

---

## 📋 Features

This script allows root users to manage system users and groups through a clean, menu-driven interface.

### 👤 User Management
- **Add User**
  - Default and custom creation options
  - Create home directory
  - Set shell, group, comment
- **Modify User**
  - Add/remove groups
  - Change home directory and move contents
  - Change shell or comment
- **List Users**
  - Display all usernames from `/etc/passwd`
- **Disable/Enable User**
  - Lock or unlock accounts
- **Change Password**
  - Set a new password with confirmation

### 👥 Group Management
- **Add Group**
  - Option to set custom GID
- **Modify Group**
  - Rename group
  - Change GID
  - Add users to group
- **Delete Group**
- **List Groups**

### ℹ️ Extras
- **About** section with script information
- **Exit** safely

---

## ⚙️ Requirements

- **Root Privileges**: Must be executed with `sudo` or as root.
- **Linux Environment**: Tested on Debian and RHEL-based systems.
- **Whiptail**: Dialog tool for interactive UI  
  Install using:
  ```bash
  sudo apt install whiptail   # Debian/Ubuntu
  sudo yum install newt       # RHEL/CentOS (includes whiptail)
  ```

---

## 🚀 How to Run

```bash
chmod +x user_admin.sh
sudo ./user_admin.sh
```

---

## 📸 Screenshot

```text
+-------------------------------------+
|            Main Menu               |
+-------------------------------------+
| Add User           | Add a user... |
| Modify User        | Modify user.. |
| List Users         | Show all....  |
| ...                                 |
+-------------------------------------+
```

---

## 🔐 Security Notes

- Passwords are securely handled using whiptail password dialogs.
- Script prevents adding existing users or groups.
- User input is validated where possible.

---
