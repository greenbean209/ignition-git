#!/bin/bash

# check if an email argument was provided
if [ -z "$1" ]
then
    echo "Usage: $0 <email>"
    exit 1
fi

# use the provided email for the ssh key
EMAIL=$1

# generate ssh key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$EMAIL" -f ~/.ssh/id_ed25519

# add ssh key to ssh agent
echo "Adding SSH key to ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Show the public key
echo "SSH Key generated successfully. The public key is:"
cat ~/.ssh/id_ed25519.pub