# Step 1: Move to the Task 1 folder
cd ~/Documents/devops/assignment2/task1

# Step 2: Create a Dockerfile
nano Dockerfile

#Docker File Content to add:

# Use Alpine as base image
FROM alpine:latest
# Install git
RUN apk update && apk add git
# Set default command
CMD ["sh"]

# Step 3: Build the Docker image and tag it as Qu1:v1.0
docker build -t Qu1:v1.0 .

# Step 4: Verify that the image was created
docker images

# Step 5: Create and run a container in the background
docker run -d --name git_container Qu1:v1.0

# Step 6: List running containers
docker ps

# Step 7: Attach to the running container
docker attach git_container

# Step 8: Inside the container, verify that Git is installed
git --version

