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
