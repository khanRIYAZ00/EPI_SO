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
