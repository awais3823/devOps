# Task 2 - Python App with Redis using Docker Compose


# Step 1: Move to the Task 2 folder
cd ~/Documents/devops/assignment2/task2

# Step 2: Create a Dockerfile
nano Dockerfile

# Add the following in Dockerfile:
# FROM python:3.9-alpine
# ADD . /code
# WORKDIR /code
# RUN pip install -r requirements.txt

# Step 3: Create docker-compose.yml
nano docker-compose.yml

# Add the following content:
# version: '3.9'
# services:
#   web:
#     build: .
#     command: python app.py
#     ports:
#       - "5000:5000"
#     volumes:
#       - .:/code
#     networks:
#       - webnet
#
#   redis:
#     image: "redis:alpine"
#     networks:
#       - webnet
#
# networks:
#   webnet:

#app.py code : simple code of hello word
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker Compose Task 2!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

# Step 4: Build and run containers
docker compose up -d --build

# Step 5: Verify running containers
docker ps

# Step 6: Access the app
# Open browser and visit: http://localhost:5000

# Step 7: Check network and volume
docker network ls
docker volume ls

# Step 8: Stop containers
docker compose down

