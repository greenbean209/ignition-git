# Use an official Ignition image as a parent image
FROM inductiveautomation/ignition:8.1.25

# Install openssh-server and git
RUN apt-get update && apt-get install -y git

# Expose Ignition Gateway ports
EXPOSE 8088 8043 8060

# add the bash scripts to handle ssh keys
COPY ssh_generate_key.sh /usr/local/bin/ssh_generate_key
COPY ssh_auto_add_keys.sh /usr/local/bin/ssh_auto_add_keys

# make them executable
RUN chmod +x /usr/local/bin/ssh_generate_key
RUN chmod +x /usr/local/bin/ssh_auto_add_keys

# Add scripts for common git operations
COPY git_setup_user.sh /usr/local/bin/git_setup_user
COPY project_init.sh /usr/local/bin/project_init
COPY project_clone.sh /usr/local/bin/project_clone
COPY project_add_remote.sh /usr/local/bin/project_add_remote
COPY project_pull.sh /usr/local/bin/project_pull
COPY project_stage_changes.sh /usr/local/bin/project_stage_changes
COPY project_commit.sh /usr/local/bin/project_commit
COPY project_push.sh /usr/local/bin/project_push

# make them executable
RUN chmod +x /usr/local/bin/git_setup_user
RUN chmod +x /usr/local/bin/project_init
RUN chmod +x /usr/local/bin/project_clone
RUN chmod +x /usr/local/bin/project_add_remote
RUN chmod +x /usr/local/bin/project_pull
RUN chmod +x /usr/local/bin/project_stage_changes
RUN chmod +x /usr/local/bin/project_commit
RUN chmod +x /usr/local/bin/project_push

# detect and add ssh keys
RUN ssh_auto_add_keys