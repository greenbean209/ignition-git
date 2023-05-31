#!/bin/bash

# check if an project name argument was provided
if [ -z "$1" ]
then
    echo "Usage: $0 <project name>"
    exit 1
fi

# pull the specified repo
PROJECT_NAME=$1
PROJECT_DIR="/usr/local/bin/ignition/data/projects/$PROJECT_NAME"
echo "Pushing to project repo to origin..."
git -C "$PROJECT_DIR" push