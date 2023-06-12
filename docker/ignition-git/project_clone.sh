#!/bin/bash

# check if repo and project name was provided
if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: $0 <repository> <project name>"
    exit 1
fi

# clone the specified repo
REPO=$1
PROJECT_NAME=$2
PROJECT_DIR="/usr/local/bin/ignition/data/projects/$PROJECT_NAME"
echo "Cloning ignition project repo..."
git clone "$REPO" "$PROJECT_DIR"