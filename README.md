# ignition-git
This repository tests the use of git with ignition projects

## Building the image
```sudo docker build . -t ignition-git-test```

## Setting Up Volumes to Persist Data

### Create an Ignition Data Volume
```bash
docker volume create --name ignition_git_test_data
```
### Create a Volume to Store SSH Keys
```bash
docker volume create -nname ignition_git_test_ssh_keys
```

## Run the Container
```bash
docker run -d --restart always -p 8088:8088 --name ignition-git-test -v ignition_git_test_data:/usr/local/bin/ignition inductiveautomation/ignition:latest -v ignition_git_test_ssh_keys:/root/.ssh ignition-git-test
```

# Demo
In this demo we will create two ignition containers.
<br>
The first will be a DEV container where we will start a new project, create a git reposistory, commit our changes, and push our code to a Github repo.
<br>
The second will be a PROD container where which is intended to run the latest versions of our ignition projects. From there we will clone the ignition project we made on DEV, and run it in PROD.

## Building the Ignition Docker Image
To accomplish our goal of using git for version control, we need have the git program available in the docker containers. We do this by installing git in the containers. The docker file in this repository shows how thats done.
<br>
To briefly describe what the dockerfile is doing, it starts with a base image "inductiveautomation/ignition:8.1.25", installs git, then adds in some bash scripts that I've written to make things a little more convenient. These scripts do things like create and add ssh keys (which are required to connect to Github),  and make some basic git functions accessible from outside the container.
<br>
Because we want to take an existing Ignition docker image from Inductive Automation and add on to it, we defined a dockerfile that create a new ignition image with our customizations. Essentially we are creating a new image, and to do that we have to run the build command.

```bash
docker build . -t ignition-git
```

This creates an image locally on our host machine that we can use to startup new containers with our customizations

## Running the Containers
We use docker run to launch the containers. Some options we are going to make use of here are the -d option which runs the container in the background. -p option to define which ports will be open on which gateways. --name to label our containers, and -v to define volumes where our data will be persisted.

### Startup the DEV container
```bash
docker run --name ignition-dev -d --restart always -p 10088:8088  -v ignition_dev_data:/usr/local/bin/ignition inductiveautomation/ignition:latest -v ignition_ssh_keys_dev:/root/.ssh -v ignition_gitconfig_dev:/root/.gitconfig ignition-git-test
```
### Startup the PROD container
```bash
docker run --name ignition-prod -d --restart always -p 10088:8088  -v ignition_prod_data:/usr/local/bin/ignition inductiveautomation/ignition:latest -v ignition_ssh_keys_prod:/root/.ssh -v ignition_gitconfig_prod:/root/.gitconfig ignition-git-test
```

## Setup the Gateways
I won't cover this in depth here, but both gateways need to go through their normal setup process when started for the first time. The fastest option is to startup standard ignition gateways in trial mode. Do this from the gateway webpages at http://hostname:10088 for DEV and http://hostname:11088 for PROD..

## Setup ssh keys on each container
To push and pull from Github, we need to have ssh keys on each container that are registered with Github and have permission to access our Github repo.
To do this we'll use a convenience function I wrote to generate the keys.

I won't cover here how to add these to github. But here's a link on how to do it: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

Also note that the ssh keys we create here will be persisted in our ignition_ssh_keys volumes. A script automatically runs at container startup to check these volumes for existing ssh keys, so you only have to add them once.

### Generate the DEV key
This command will generate a key pair for the DEV container and print out the public key for you to copy and paste to github.
It also automatically adds the key to the ssh-agent, which normally is an extra step.
```bash
docker exec -it ignition-dev ssh_generate_key "email@example.com"
```

### Generate the PROD key
This command does the same for the PROD container.
```bash
docker exec -it ignition-prod ssh_generate_key "email@example.com"
```

## Setup git identity on each container
This command lets you provide a user and email to git so it can add your identity to any commits you make
```bash
docker exec -it ignition-dev git_setup_user username "email@example.com"
```
```bash
docker exec -it ignition-prod ssh_generate_key username "email@example.com"
```

## Create a project repo on Github
On Github, create a new repo, chose whatever name you like for it but for my purposes I will use "ignition-hello-world".
Set it up as a blank repo, no readme file, no git ignore. We will push our project files in later.
Copy out the repo address for later. For me its "git@github.com:greenbean209/ignition-hello-world.git"

This will be the repo that stores the actual ignition project. If you have multiple projects, that woud meean multiple repos.
This isn't the only option when using git with ignition but it's the route I've taken.

## Create an Ignition project
Startup an Ignition designer for the DEV gateway and make a new project. Name it whatever you like, but in my case I'll have it match my repo name.
Take note of the project name, this will be the name of the folder that houses the project files.

Add some content to the project like a perspective view or something.

When your done, navigate to the perspective project url on the DEV gateway and verify everything is working.

## Initialize and Push the Project to Github
Now that our project is created, a folder will exist in the ignition data/projects directory for our project.
Here's a basic outline of what we still need to do to push this project to Github.

<ol>
<li> Initialize a git repo in the project folder
<li> Setup our git repo to push and pull from a Github repo
<li> Commit our files and changes to the repo
<li> Push our commit to Github
</ol>

If you're already familiar with git you'll know how to do this. If not I'll show you what that looks like.
However docker makes things a little more complicated here, because we have access the command prompt of our container to run these commands, you'd have to run this to start a bash session on the container first.

```bash
docker exec -it ignition-dev bash
```
Now that you're inside the container you'll have to navigate to the project folder
```bash
cd /usr/local/bin/ignition/data/projects/ignition-hello-world
```
Finally you can run the git commands to make initialize the repo, make a first commit, and push it to github
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:greenbean209/ignition-hello-world.git
git push origin main
```

I've written some scripts to make this process a little easier. Keep reading to see how.


### Ignition Project Management Scripts
I wrote a few scripts to make it 

This script also gives you an option of adding the Github repository and commiting and pushing the project so far.
Follow the prompts after running this.


```bash
docker exec -it ignition-dev proj-git ignition-hello-world init
```

If, you chose not to make use of the prompts in the init script, here's how you can perform each step manually

```bash
docker exec -t ignition-dev project_add_remote ignition-hello-world git@github.com:greenbean209/ignition-hello-world.git
```

Here's a 