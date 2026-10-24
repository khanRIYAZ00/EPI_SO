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
