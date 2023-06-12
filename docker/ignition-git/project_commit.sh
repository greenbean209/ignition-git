#!/bin/bash

# Check if username and email args are provided
if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: $0 <project name> <commit message>"
    exit 1
fi

# Commit staged changes
PROJECT_NAME=$1
COMMIT_MESSAGE=$2
PROJECT_DIR="/usr/local/bin/ignition/data/projects/$PROJECT_NAME"
echo "Committing to project repo..."
git -C "$PROJECT_DIR" commit -m "$COMMIT_MESSAGE"