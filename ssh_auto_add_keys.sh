#!/bin/bash

echo 'Starting ssh-agent..'
# Ensure ssh-agent is running
eval "$(ssh-agent -s)"

echo 'Adding existing keys...'
# Add any keys found in /ssh-keys to the ssh-agent
for key in /root/.ssh/*; do
	if [[ $key != *.pub ]]; then
		echo "Found key: $key"
		ssh-add "$key"
    fi
done

echo "Done adding keys."