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
