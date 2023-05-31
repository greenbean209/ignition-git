#!/bin/bash

# Check if username and email args are provided
if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Usage: $0 <username> <email>"
    exit 1
fi

# Add to git config
USER=$1
EMAIL=$2
git config --global user.name "$USER"
git config --global user.email "$EMAIL"