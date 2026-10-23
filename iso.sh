#!/usr/bin/env bash
# run.sh - OSL lab experiments 1-10 (Khan Mohd Riyaz, TE-CO-1, 24CO47)
# Usage:  ./run.sh        (menu)      ./run.sh 7   (run experiment 7 directly)
# Everything is created under ~/Desktop/practical (except the packages / users /
# web-server files that an experiment installs through sudo, as the lab requires).

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run this script as root or with sudo; it calls sudo itself where needed."
  exit 1
fi

DESK="$(xdg-user-dir DESKTOP 2>/dev/null)"
if [ -z "$DESK" ] || [ "$DESK" = "$HOME" ]; then DESK="$HOME/Desktop"; fi
P="$DESK/practical"
mkdir -p "$P"
cd "$P" || exit 1

# ----------------------------------------------------------------- helpers
do_clear() { clear 2>/dev/null || printf '\033[H\033[2J'; }

ask_yes() {            # ask_yes "Question?"  -> 0 only for y / yes
  printf '%s [y/N] ' "$1"
  read -r _ans
  case "$_ans" in y|Y|yes|YES|Yes) return 0 ;; *) return 1 ;; esac
}

ask_val() {            # ask_val "Prompt" default VARNAME
  printf '%s [%s]: ' "$1" "$2"
  read -r _val
  printf -v "$3" '%s' "${_val:-$2}"
}

fresh() {              # remove a previous run's sub-folder of the lab folder
  case "$1" in ""|*/*|.|..) return 1 ;; esac
  rm -rf -- "$P/$1"
}

need_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then echo "sudo is not installed."; return 1; fi
  sudo -v || { echo "sudo authentication failed."; return 1; }
}

# =================================================================== README writers
readme_01() {
cat > "$P/README_exp01_VirtualBox_Ubuntu.md" <<'EOF'
# Experiment 1 - Install and configure Ubuntu on Oracle VM VirtualBox

`./run.sh 1` automates the checks and the VM creation (name, RAM, CPUs, 25 GB disk,
ISO attached). Installing Ubuntu inside the VM is a graphical task and is manual.

## Manual steps
1. If `./run.sh 1` did not install VirtualBox, install it: `sudo apt-get install -y virtualbox`
   (or download the installer from https://www.oracle.com/in/virtualization/virtualbox/).
2. Download the Ubuntu Desktop ISO from https://ubuntu.com/download/desktop
   (re-run `./run.sh 1` and give the ISO path when asked, or attach it in
   VM > Settings > Storage > Empty optical drive > choose a disk file).
3. Open VirtualBox, select the VM "Ubuntu", check Settings > System (RAM/CPU),
   Display and Storage (this is the "Configure VM Settings" step).
4. Click Start. In the Ubuntu installer choose language, keyboard layout and
   "Erase disk and install Ubuntu" (this only erases the virtual disk).
5. Create your username and password, finish the install, click "Restart now",
   remove the ISO if asked and press Enter.
6. Take screenshots for "Output of Execution": VirtualBox manager with the VM,
   the Ubuntu installer, and the Ubuntu desktop after first login.
7. Optional: Devices > Insert Guest Additions CD image, then run the installer
   inside the VM and reboot, for better display and clipboard integration.

## Troubleshooting
- "VT-x/AMD-V is disabled": reboot, enter BIOS/UEFI, enable Intel Virtualization
  Technology or AMD-V (SVM), save and reboot. The first command of `./run.sh 1`
  prints a count greater than 0 when the CPU flag is visible to Linux.
- Slow / laggy guest: give the VM more RAM and CPU cores in Settings > System and
  install Guest Additions.
- "Kernel driver not installed (rc=-1908)" or modules fail to load after installing
  VirtualBox: if Secure Boot is on, enrol the MOK key when the blue screen appears at
  reboot, or turn Secure Boot off. Then run `sudo /sbin/vboxconfig`.
- The VM files are in ~/Desktop/practical/VirtualBox_VMs. To remove the VM:
  `VBoxManage unregistervm Ubuntu --delete`.
EOF
}

readme_03() {
cat > "$P/README_exp03_Users_Groups_Permissions.md" <<'EOF'
# Experiment 3 - Users, groups, permissions and ACLs

`./run.sh 3` runs the whole procedure for real (after you confirm). It changes the
system on purpose, as the experiment requires:
- group `developers`; users `student1`, `student2`, `outsider`
- directory `/project` with `/project/student1_file.txt`
- package `acl` (if missing)

## Manual steps
1. Run `./run.sh 3`, type `y`, enter your sudo password.
2. Take screenshots of the terminal for "Output of Execution".
3. Check the expected results in the output:
   - `/project` shows `drwxrwx---` owned by `root developers`
   - student2 can append to student1's file (file ends with both lines)
   - `sudo -u outsider ls /project` says "Permission denied"
   - after `setfacl`, outsider can `cat` the file but the append fails
   - after `setfacl -x`, `getfacl` shows no `user:outsider` line

## Clean up (when you are finished)
    sudo setfacl -R -b /project
    sudo rm -rf /project
    sudo userdel -r student1
    sudo userdel -r student2
    sudo userdel -r outsider
    sudo groupdel developers

## Troubleshooting
- `groupadd: group 'developers' already exists`, `useradd: user ... already exists`,
  `mkdir: cannot create directory '/project': File exists`: left over from an earlier
  run. Harmless; the next commands still work. Use the clean-up above to start fresh.
- Lines like `cp: cannot create directory '/home/student1/./.config/...': Permission denied`
  or `chown: changing ownership ... Operation not permitted`: some distributions (e.g.
  Linux Mint) run a first-login helper for new accounts. They are noise and do not
  affect the experiment.
- `getfacl: ... Permission denied`: run `getfacl` with sudo (the script does).
- `setfacl: command not found`: `sudo apt-get install -y acl`.
- Student2 cannot modify the file: `sudo chgrp developers /project/student1_file.txt`
  and `sudo chmod 660 /project/student1_file.txt`.
EOF
}

readme_06() {
cat > "$P/README_exp06_Apache_SQLite.md" <<'EOF'
# Experiment 6 - Apache web server and SQLite database

`./run.sh 6` installs Apache2 and SQLite3, starts Apache, fixes the ServerName
warning, publishes a test page, tests it with curl and runs the SQLite steps.
Your previous /var/www/html/index.html (if any) is saved to
~/Desktop/practical/webdbprac_backup_index.html before it is replaced.

## Manual steps
1. Run `./run.sh 6`, type `y`, enter your sudo password.
2. Open a browser and visit http://localhost . The page must show
   "Welcome to Open Source Web Server Practical". Take a screenshot.
3. Take a screenshot of the terminal output (curl HTML and the two student rows).
4. Optional: open `sqlite3 ~/Desktop/practical/webdbprac/student.db` and try
   `.tables`, `.schema students`, `SELECT * FROM students;`, `.quit`.

## Restore the original Apache page (optional)
    sudo cp ~/Desktop/practical/webdbprac_backup_index.html /var/www/html/index.html

## Troubleshooting
- "Could not reliably determine the server's fully qualified domain name": this is a
  warning, not an error. The script adds `ServerName localhost` to
  /etc/apache2/apache2.conf and restarts Apache, which removes it.
- `curl: (7) Failed to connect`: Apache is not running. Use `sudo service apache2 start`
  (or `sudo apache2ctl start` where there is no service manager) and check
  `sudo service apache2 status`.
- Port 80 already in use: `sudo ss -ltnp | grep ':80'`, stop the other server
  (for example `sudo service nginx stop`).
- `sqlite3: command not found`: `sudo apt-get install -y sqlite3`.
- The lab sheet mentions a fixed IP (172.61.1.34); that was specific to the lab
  machine. Use `localhost` or your own IP from `hostname -I`.
EOF
}

readme_07() {
cat > "$P/README_exp07_Git.md" <<'EOF'
# Experiment 7 - Git version control

`./run.sh 7` runs the whole procedure for real. Your real ~/.gitconfig is NOT touched:
the "global" Git settings of this experiment live in
~/Desktop/practical/exp7_gitconfig (the script sets GIT_CONFIG_GLOBAL for its own run).

By default the remote is a local bare repository
(~/Desktop/practical/git_remote/git-experiment.git), so push works offline.
To push to a real GitHub/GitLab repository, paste its URL when the script asks for it.

## Manual steps (real GitHub/GitLab remote)
1. On GitHub: New repository, name `git-experiment`, leave it EMPTY (no README/licence).
2. Copy its HTTPS URL, e.g. https://github.com/<your-id>/git-experiment.git
3. Run `./run.sh 7` and paste the URL when asked for the remote.
4. When Git asks for a password, use a Personal Access Token (GitHub > Settings >
   Developer settings > Personal access tokens), not your account password.
5. Refresh the repository page and take a screenshot showing README.md, feature.txt
   and the 2 commits. Also screenshot the terminal for "Output of Execution".

To continue by hand later:

    cd ~/Desktop/practical/git-experiment
    git remote -v
    git log --oneline

## Troubleshooting
- `error: src refspec main does not match any`: your branch is called master.
  Run `git branch -M main` and push again.
- `remote origin already exists`: `git remote set-url origin <repository-url>`.
- `Authentication failed` / `Permission denied (publickey)`: use a Personal Access
  Token over HTTPS, or add an SSH key to your account.
- `rejected ... fetch first`: the remote repo was not empty. Create it again empty.
- The lab sheet's "Create README.md" and "commit further changes on the feature
  branch" steps have no command; the script adds them (README.md and feature.txt).
EOF
}

readme_10() {
cat > "$P/README_exp10_GitHub_Contribution.md" <<'EOF'
# Experiment 10 - Open source contribution (Fork -> PR)

`./run.sh 10` replays the full local part of the workflow offline: a simulated
upstream repo and a simulated fork (local bare repositories under
~/Desktop/practical/exp10_github_sim), then clone, branch, edit, diff, commit and push.
Your real ~/.gitconfig is NOT touched (GIT_CONFIG_GLOBAL points to
~/Desktop/practical/exp10_gitconfig).

Forking and the Pull Request exist only on GitHub, so those parts are manual.

## Manual steps (real GitHub)
1. Sign in to GitHub as `khanRIYAZ00` (or your own ID).
2. Open https://github.com/firstcontributions/first-contributions and click Fork,
   owner = your account. Screenshot the fork page.
3. In a terminal:

       mkdir -p ~/Desktop/practical/oss_contribution_real && cd ~/Desktop/practical/oss_contribution_real
       git config --global user.name "Khan Mohd Riyaz"
       git config --global user.email "24co47@aiktc.ac.in"
       git clone https://github.com/khanRIYAZ00/first-contributions.git
       cd first-contributions
       git status
       git remote -v
       git checkout -b docs/riyaz-readme
       printf '\n## Contribution Note\n\nIf you are new to open source, start with small documentation changes and follow the project'"'"'s contribution guidelines.\n' >> README.md
       git diff
       git add README.md
       git commit -m "docs: improve contribution guide"
       git push -u origin docs/riyaz-readme

   (`git config --global` here changes your real ~/.gitconfig; skip those two lines if
   Git is already configured.)
4. On your fork's page click "Compare & pull request".
   Base repository: firstcontributions/first-contributions, base: main.
   Compare: khanRIYAZ00:docs/riyaz-readme.
   Title: `docs: improve contribution guide`
   Description: "This pull request adds a small contribution note to the README. It
   provides guidance for beginners who want to start contributing to open source."
5. Click "Create pull request". Screenshot the PR page and paste its URL in your report
   (the PR number is assigned by GitHub; do not reuse the number from another student).
6. Verify with `git status` and `git branch -a`.

## Troubleshooting
- `Authentication failed`: use a Personal Access Token as the password, or run
  `gh auth login` (GitHub CLI), or set up an SSH key.
- `fatal: destination path 'first-contributions' already exists`: delete or rename
  the old folder, or `cd` into it and continue.
- `Author identity unknown`: set `git config user.name` / `user.email`.
- Pull request shows conflicts: `git fetch upstream` after adding
  `git remote add upstream https://github.com/firstcontributions/first-contributions.git`,
  then `git rebase upstream/main` and `git push --force-with-lease`.
- Note: the lab sheet's steps contain another student's name, fork and branch
  (Aqdas); use your own GitHub ID and branch name as above.
EOF
}

# =================================================================== experiments
exp1() {
  readme_01
  VM="Ubuntu"; VMDIR="$P/VirtualBox_VMs"
  _kb="$(awk '/MemTotal/{print $2}' /proc/meminfo 2>/dev/null)"
  MEM=2048; [ "${_kb:-0}" -ge 7000000 ] && MEM=4096
  CPUS=2; [ "$(nproc 2>/dev/null || echo 1)" -lt 4 ] && CPUS=1

  PS4='$ '
  set -x
  grep -E -c '(vmx|svm)' /proc/cpuinfo
  lscpu | grep -i virtualization
  free -h
  df -h "$P"
  nproc
  { set +x; } 2>/dev/null

  if ! command -v VBoxManage >/dev/null 2>&1; then
    if ask_yes "VirtualBox is not installed. Install it with apt (needs sudo)?"; then
      need_sudo || return 1
      set -x
      sudo apt-get update
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y virtualbox
      { set +x; } 2>/dev/null
    fi
  fi

  if command -v VBoxManage >/dev/null 2>&1; then
    set -x
    VBoxManage --version
    { set +x; } 2>/dev/null
    if VBoxManage list vms 2>/dev/null | grep -q "\"$VM\""; then
      echo "A VM named $VM already exists; not creating another one."
    elif ask_yes "Create a VirtualBox VM named $VM (${MEM} MB RAM, $CPUS CPU, 25 GB disk) in $VMDIR?"; then
      printf 'Path to the Ubuntu Desktop ISO (Enter to skip): '
      read -r ISO
      case "$ISO" in "~/"*) ISO="$HOME/${ISO#\~/}" ;; esac
      mkdir -p "$VMDIR"
      set -x
      VBoxManage createvm --name "$VM" --ostype Ubuntu_64 --basefolder "$VMDIR" --register
      VBoxManage modifyvm "$VM" --memory "$MEM" --cpus "$CPUS" --vram 16 --graphicscontroller vmsvga --nic1 nat
      VBoxManage createmedium disk --filename "$VMDIR/$VM/$VM.vdi" --size 25600 --format VDI
      VBoxManage storagectl "$VM" --name SATA --add sata --controller IntelAhci
      VBoxManage storageattach "$VM" --storagectl SATA --port 0 --device 0 --type hdd --medium "$VMDIR/$VM/$VM.vdi"
      { set +x; } 2>/dev/null
      if [ -n "$ISO" ] && [ -r "$ISO" ]; then
        set -x
        VBoxManage storagectl "$VM" --name IDE --add ide
        VBoxManage storageattach "$VM" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "$ISO"
        { set +x; } 2>/dev/null
      else
        echo "No readable ISO given; attach it later (see the README)."
      fi
      set -x
      VBoxManage showvminfo "$VM" --machinereadable | grep -E '^(name|memory|cpus|ostype)='
      { set +x; } 2>/dev/null
    fi
  else
    echo "VBoxManage not found, so no VM was created. Follow the README."
  fi
  echo "Manual steps (installing Ubuntu in the VM): $P/README_exp01_VirtualBox_Ubuntu.md"
}

exp2() {
  fresh fs_prac; mkdir -p "$P/fs_prac"; cd "$P/fs_prac" || return 1
  PS4='$ '
  set -x
  pwd
  ls /
  ls -ld /bin /boot /dev /etc /home /root /tmp /usr /var
  mkdir Documents
  ls
  cd Documents
  pwd
  touch notes.txt
  ls
  { set +x; } 2>/dev/null
}

exp3() {
  readme_03
  echo "This experiment changes the system: it creates the group 'developers', the users"
  echo "student1, student2 and outsider, the directory /project, and installs 'acl' if missing."
  ask_yes "Continue?" || { echo "Cancelled. Nothing was changed."; return 0; }
  need_sudo || return 1
  cd / || return 1
  PS4='$ '
  set -x
  whoami
  id
  sudo groupadd developers
  getent group developers
  sudo useradd -m -s /bin/bash student1
  sudo useradd -m -s /bin/bash student2
  id student1
  id student2
  sudo usermod -aG developers student1
  sudo usermod -aG developers student2
  groups student1
  groups student2
  sudo mkdir /project
  ls -ld /project
  sudo chown root:developers /project
  ls -ld /project
  sudo chmod 770 /project
  ls -ld /project
  sudo -u student1 touch /project/student1_file.txt
  sudo -u student1 bash -c 'echo "Created by student1" > /project/student1_file.txt'
  sudo cat /project/student1_file.txt
  sudo ls -l /project
  sudo chgrp developers /project/student1_file.txt
  sudo chmod 660 /project/student1_file.txt
  sudo ls -l /project/student1_file.txt
  sudo -u student2 bash -c 'echo "Edited by student2" >> /project/student1_file.txt'
  sudo cat /project/student1_file.txt
  sudo useradd -m -s /bin/bash outsider
  groups outsider
  sudo -u outsider ls /project
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y acl
  sudo setfacl -m u:outsider:rx /project
  sudo setfacl -m u:outsider:r /project/student1_file.txt
  sudo getfacl /project/student1_file.txt
  sudo -u outsider cat /project/student1_file.txt
  sudo -u outsider bash -c 'echo "Edited by outsider" >> /project/student1_file.txt'
  sudo setfacl -x u:outsider /project/student1_file.txt
  sudo setfacl -x u:outsider /project
  sudo getfacl /project/student1_file.txt
  { set +x; } 2>/dev/null
  cd "$P" || return 1
  echo "Clean-up commands and troubleshooting: $P/README_exp03_Users_Groups_Permissions.md"
}

exp4() {
  fresh shellprac
  PS4='$ '
  set -x
  mkdir shellprac
  cd shellprac
  pwd
  printf '%s\n' '#!/bin/bash' 'echo "File Handling Started"' 'mkdir -p datafiles' 'echo "Hello Linux" > datafiles/file1.txt' 'echo "Shell Scripting Practical" > datafiles/file2.txt' 'echo "Files created successfully"' 'ls -l datafiles' > filehandling.sh
  bash filehandling.sh
  rm -f backup.sh
  printf '%s\n' '#!/bin/bash' 'echo "Backup Started"' 'mkdir -p backupcopy' 'cp -r datafiles backupcopy/' 'echo "Backup completed successfully"' 'ls -l backupcopy' > backup.sh
  bash backup.sh
  rm -f process.sh
  printf '%s\n' '#!/bin/bash' 'echo "Process Management Started"' 'echo "Current User:"' 'whoami' 'echo "Running Processes:"' 'ps | head -n 5' > process.sh
  bash process.sh
  ls
  ls backupcopy
  ls datafiles
  { set +x; } 2>/dev/null
}

exp5() {
  if dpkg -s tree >/dev/null 2>&1; then
    echo "The package 'tree' is already installed. This experiment removes it at the end"
    echo "(reinstall later with: sudo apt-get install -y tree)."
  else
    echo "This experiment installs the package 'tree' and removes it again at the end."
  fi
  ask_yes "Continue?" || { echo "Cancelled. Nothing was changed."; return 0; }
  need_sudo || return 1
  fresh pkgprac
  PS4='$ '
  set -x
  mkdir pkgprac
  cd pkgprac
  pwd
  cat /etc/os-release | head -n 2
  sudo apt-get update
  apt-cache search '^tree$'
  apt-cache depends tree
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tree
  tree --version
  mkdir demo
  mkdir demo/docs
  mkdir demo/images
  touch demo/docs/file1.txt
  touch demo/docs/file2.txt
  touch demo/images/photo1.png
  tree demo
  dpkg -l | grep tree
  sudo apt-get remove -y tree
  tree --version
  { set +x; } 2>/dev/null
}

exp6() {
  readme_06
  echo "This experiment installs apache2 and sqlite3, edits /etc/apache2/apache2.conf"
  echo "(adds ServerName localhost) and replaces /var/www/html/index.html (a backup is kept)."
  ask_yes "Continue?" || { echo "Cancelled. Nothing was changed."; return 0; }
  need_sudo || return 1
  fresh webdbprac
  PS4='$ '
  set -x
  mkdir webdbprac
  cd webdbprac
  pwd
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 sqlite3
  sudo service apache2 start
  curl http://localhost
  { set +x; } 2>/dev/null
  if ! grep -q '^ServerName localhost' /etc/apache2/apache2.conf 2>/dev/null; then
    set -x
    printf 'ServerName localhost\n' | sudo tee -a /etc/apache2/apache2.conf
    { set +x; } 2>/dev/null
  fi
  [ -f /var/www/html/index.html ] && [ ! -f "$P/webdbprac_backup_index.html" ] && cp /var/www/html/index.html "$P/webdbprac_backup_index.html"
  set -x
  sudo service apache2 restart
  sudo service apache2 status
  printf '<h1>Welcome to Open Source Web Server Practical</h1>\n' | sudo tee /var/www/html/index.html
  curl http://localhost
  sqlite3 student.db "CREATE TABLE students(id INTEGER, name TEXT, course TEXT);"
  sqlite3 student.db "INSERT INTO students VALUES(1, 'Amit', 'Linux');"
  sqlite3 student.db "INSERT INTO students VALUES(2, 'Riya', 'Database');"
  sqlite3 student.db "SELECT * FROM students;"
  curl http://localhost
  sqlite3 student.db "SELECT * FROM students;"
  { set +x; } 2>/dev/null
  echo "Browser check and troubleshooting: $P/README_exp06_Apache_SQLite.md"
}

exp7() {
  readme_07
  ask_val "Git user name" "Khan Mohd Riyaz" GN
  ask_val "Git user email" "24co47@aiktc.ac.in" GE
  REMOTE="$P/git_remote/git-experiment.git"
  printf 'Remote repository URL (Enter = local demo remote): '
  read -r URL
  [ -n "$URL" ] && REMOTE="$URL"
  fresh git-experiment; fresh git_remote
  if [ -z "$URL" ]; then
    mkdir -p "$P/git_remote"
    git init -q --bare "$REMOTE"
    git -C "$REMOTE" symbolic-ref HEAD refs/heads/main
  fi
  printf '[init]\n\tdefaultBranch = main\n' > "$P/exp7_gitconfig"
  export GIT_CONFIG_GLOBAL="$P/exp7_gitconfig"
  PS4='$ '
  set -x
  git config --global user.name "$GN"
  git config --global user.email "$GE"
  git config --list
  mkdir git-experiment
  cd git-experiment
  git init
  printf '# Git Experiment\n\nThis repository demonstrates basic Git version control.\n' > README.md
  git status
  git add README.md
  git commit -m "Initial commit"
  git log --oneline
  git branch feature
  git switch feature
  printf 'Feature added on the feature branch.\n' > feature.txt
  git add .
  git commit -m "Added feature"
  git switch main
  git merge feature
  git remote add origin "$REMOTE"
  git remote -v
  git push -u origin main
  git log --oneline
  { set +x; } 2>/dev/null
  cd "$P" || return 1
  echo "Using a real GitHub/GitLab remote and troubleshooting: $P/README_exp07_Git.md"
}

exp8() {
  fresh opensourceprac
  printf '[init]\n\tdefaultBranch = master\n' > "$P/exp8_gitconfig"
  export GIT_CONFIG_GLOBAL="$P/exp8_gitconfig"
  PS4='$ '
  set -x
  git --version
  mkdir opensourceprac
  cd opensourceprac
  pwd
  git init
  git config user.name "Student"
  git config user.email "student@example.com"
  printf '# Open Source Project\n' > README.md
  printf 'This is a sample open-source project.\n' >> README.md
  cat README.md
  git add README.md
  git commit -m "Initial project setup"
  printf 'Issue 1: Add project description in README file\n' > issue1.txt
  cat issue1.txt
  git checkout -b fixissue1
  printf 'Project description: This project demonstrates open-source workflow and issue tracking.\n' >> README.md
  cat README.md
  git add README.md
  git commit -m "Fix issue 1 by adding project description"
  git checkout master
  git merge fixissue1
  printf 'Issue 1 Status: Closed after adding project description\n' > issue1status.txt
  cat issue1status.txt
  git log --oneline
  ls
  cat README.md
  cat issue1status.txt
  { set +x; } 2>/dev/null
}

exp9() {
  if ! command -v gcc >/dev/null 2>&1 || ! command -v make >/dev/null 2>&1; then
    if ask_yes "gcc/make not found. Install build-essential with apt (needs sudo)?"; then
      need_sudo || return 1
      set -x
      sudo apt-get update
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential
      { set +x; } 2>/dev/null
    else
      echo "Cancelled: gcc and make are required."; return 0
    fi
  fi
  fresh ossprac
  PS4='$ '
  set -x
  mkdir ossprac
  cd ossprac
  pwd
  gcc --version
  make --version
  printf '#include <stdio.h>\n\nint main() {\n    printf("Hello from Open Source App\\n");\n    return 0;\n}\n' > helloapp.c
  cat helloapp.c
  printf 'helloapp: helloapp.c\n\tgcc helloapp.c -o helloapp\n\nclean:\n\trm -f helloapp\n' > Makefile
  cat Makefile
  make
  ls -l
  ./helloapp
  printf '# Hello Open Source App\n' > README.md
  printf 'This is a simple C application created for OSS practical.\n' >> README.md
  printf 'Build command: make\n' >> README.md
  printf 'Run command: ./helloapp\n' >> README.md
  cat README.md
  printf 'MIT License\n' > LICENSE
  printf 'Permission is hereby granted to use, copy, modify, and distribute this software.\n' >> LICENSE
  printf 'This software is provided without warranty.\n' >> LICENSE
  cat LICENSE
  head -n 1 LICENSE
  grep -i "MIT" LICENSE
  ls README.md LICENSE
  grep -i "Permission" LICENSE
  printf 'This project uses MIT License.\n' > NOTICE.txt
  printf 'Users must keep the LICENSE file while sharing the project.\n' >> NOTICE.txt
  cat NOTICE.txt
  make clean
  ls
  { set +x; } 2>/dev/null
}

exp10() {
  readme_10
  ask_val "Git user name" "Khan Mohd Riyaz" GN
  ask_val "Git user email" "24co47@aiktc.ac.in" GE
  ask_val "GitHub user ID (used for the simulated fork)" "khanRIYAZ00" GH
  SIM="$P/exp10_github_sim"
  UP="$SIM/firstcontributions/first-contributions.git"
  FORK="$SIM/$GH/first-contributions.git"
  fresh oss_contribution; fresh exp10_github_sim
  mkdir -p "$SIM/firstcontributions"
  # seed the simulated upstream repository (stands in for github.com/firstcontributions/first-contributions)
  git init -q -b main "$SIM/seed"
  printf '# First Contributions\n\nThis is a practice repository for first-time open-source contributors.\n\n## How to contribute\n\n1. Fork the repository.\n2. Clone your fork.\n3. Create a branch.\n4. Make a change, commit and push.\n5. Open a Pull Request.\n' > "$SIM/seed/README.md"
  printf '# Contributors\n\n- Example Contributor\n' > "$SIM/seed/Contributors.md"
  printf 'MIT License\n' > "$SIM/seed/LICENSE"
  mkdir -p "$SIM/seed/docs"
  printf '# Docs\n\nSee the README for instructions.\n' > "$SIM/seed/docs/README.md"
  git -C "$SIM/seed" add -A
  git -C "$SIM/seed" -c user.name="Maintainer" -c user.email="maintainer@example.com" commit -q -m "Initial commit"
  git clone -q --bare "$SIM/seed" "$UP"
  rm -rf "$SIM/seed"
  printf '[init]\n\tdefaultBranch = main\n' > "$P/exp10_gitconfig"
  export GIT_CONFIG_GLOBAL="$P/exp10_gitconfig"
  PS4='$ '
  set -x
  mkdir oss_contribution
  cd oss_contribution
  pwd
  git --version
  git config --global user.name "$GN"
  git config --global user.email "$GE"
  git config --global --list
  git clone --bare "$UP" "$FORK"
  git clone "$FORK" first-contributions
  cd first-contributions
  git status
  git remote -v
  git checkout -b docs/riyaz-readme
  git branch
  git status
  ls
  head -40 README.md
  printf '\n## Contribution Note\n\nIf you are new to open source, start with small documentation changes and follow the project'"'"'s contribution guidelines.\n' >> README.md
  tail -8 README.md
  git status
  git diff
  git add README.md
  git status
  git commit -m "docs: improve contribution guide"
  git log -1 --oneline
  git push -u origin docs/riyaz-readme
  git status
  git branch -a
  { set +x; } 2>/dev/null
  cd "$P" || return 1
  echo "Fork and Pull Request on real GitHub (manual): $P/README_exp10_GitHub_Contribution.md"
}

# =================================================================== menu
NAMES=(
  ""
  "Install and configure Ubuntu on VirtualBox"
  "Linux file system hierarchy and basic commands"
  "Users, groups, permissions and ACLs"
  "Shell scripting (file handling, backup, process)"
  "Package management (apt, apt-cache, dpkg)"
  "Apache web server and SQLite database"
  "Git version control"
  "Open-source workflow and issue tracking"
  "Build from source, documentation and license check"
  "Open source contribution (GitHub fork and pull request)"
)

do_clear
if [ -n "$1" ]; then
  N="$1"
else
  echo "Select experiment:"
  for i in 1 2 3 4 5 6 7 8 9 10; do echo "$i - ${NAMES[$i]}"; done
  printf 'Enter experiment number: '
  read -r N
  do_clear
fi

case "$N" in
  1) exp1 ;;  2) exp2 ;;  3) exp3 ;;  4) exp4 ;;  5) exp5 ;;
  6) exp6 ;;  7) exp7 ;;  8) exp8 ;;  9) exp9 ;;  10) exp10 ;;
  *) echo "Invalid experiment number: $N"; exit 1 ;;
esac
