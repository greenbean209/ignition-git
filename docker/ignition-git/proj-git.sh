#!/bin/bash

# Your base directory
BASE_DIR="/usr/local/bin/ignition/data/projects"

# Check if a project name was given
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <project> <git command>"
    exit 1
fi

# Get the project name
PROJECT_NAME=$1

# Remove the project name from the arguments array
shift

# Handle "projects" project name as the base dir
if [ "$PROJECT_NAME" = "projects"]; then
	# Execute the command from the base dir
	cd "$BASE_DIR"
	git "$@"

# Else handle it like a regular project dir
else 
	# Check if the project directory exists
	PROJECT_DIR="$BASE_DIR/$PROJECT_NAME"
	if [ ! -d "$PROJECT_DIR" ]; then
		echo "Error: Project directory $PROJECT_DIR does not exist."
		exit 2
	else
		# Execute the git command in the project directory
		cd "$PROJECT_DIR"
		git "$@"
	fi
fi