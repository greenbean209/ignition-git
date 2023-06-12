#!/bin/bash

# check if an project name and remote origin argument was provided
if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: $0 <project name> <remote origin repo>"
    exit 1
fi


# Add a remote origin to the project
PROJECT_NAME=$1
PROJECT_DIR="/usr/local/bin/ignition/data/projects/$PROJECT_NAME"
echo "Initializing project git repo..."
git -C "$PROJECT_DIR" remote add origin "$REMOTE_ORIGIN"