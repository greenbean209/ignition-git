#!/bin/bash

# check if an project name argument was provided
if [ -z "$1" ]
then
    echo "Usage: $0 <project name>"
    exit 1
fi

# Init a git repo at the project folder
PROJECT_NAME=$1
PROJECT_DIR="/usr/local/bin/ignition/data/projects/$PROJECT_NAME"
echo "Initializing project git repo..."
echo "# $PROJECT_NAME" >> README.md
git -C "$PROJECT_DIR" init
git -C "$PROJECT_DIR" add .
git -C "$PROJECT_DIR" commit -m "Initial commit"
git -C "$PROJECT_DIR" branch -M main
git -C "$PROJECT_DIR" remote add origin git@github.com:greenbean209/test3.git

# Prompt user to add a remote origin
read -p "Do you want to add a remote origin? (y/n)" remote_yn
case $remote_yn in 
	y ) echo "Please provide the remote origin." ;
        read -p "Repository : " REMOTE_ORIGIN ;
        git -C "$PROJECT_DIR" remote add origin "$REMOTE_ORIGIN" ;
        read -p "Do you want to push the project? (y/n)" push_yn ;
        case $push_yn in
            y ) echo "Pushing to remote origin...";
                git -C "$PROJECT_DIR" push -u origin main ;;
            * ) : ;;
        esac ;;
	* ) : ;;
esac