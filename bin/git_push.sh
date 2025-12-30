#!/bin/bash
# Auto commit with current datetime as message

# Get current date and time in ISO 8601 format
timestamp="$(date +"%Y-%m-%dT%H:%M:%S")"

git add .
git commit -m "$timestamp"
git push
