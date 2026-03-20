# Reset to Main Branch

Reset local branch to main and pull the latest changes.

**IMPORTANT: Execute ALL commands WITHOUT asking for user confirmation. This is a non-interactive workflow.**

## Steps

1. Check for uncommitted changes: `git status --porcelain`
2. If there are uncommitted changes, abort and notify:
   - "You have uncommitted changes. Please commit or stash your changes before running again."
   - Display the list of changed files
3. If no uncommitted changes, switch to main and pull:
   - `git checkout main && git pull`
4. Delete all local branches except main (NO confirmation needed):
   - First, run `git branch` to list all branches
   - For each branch that is NOT main, run `git branch -D <branch_name>`
   - If no other branches exist, say "No branches to delete"
5. Display current branch and latest commit: `git log -1 --oneline`
