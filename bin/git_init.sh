#!/usr/bin/env bash
# Usage: script.sh <repo-name> [files] [commit-message]

gitinit() {
  local repo_name="$1"
  local add_files="${2:-.}"
  local commit_msg="${3:-Initial commit}"

  if [ -z "$repo_name" ]; then
    echo "Usage: gitinit <repo-name> [files] [commit-message]"
    return 1
  fi

  git init
  git remote add origin "https://github.com/$USER/$repo_name.git"
  git branch -M main
  git add $add_files
  git commit -m "$commit_msg"
  git push -u origin main
}
