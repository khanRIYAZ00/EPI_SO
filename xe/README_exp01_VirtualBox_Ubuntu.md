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
