#!/bin/bash
# Login to AWS ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 891377050051.dkr.ecr.ap-south-1.amazonaws.com

# Pull the latest image
docker pull 891377050051.dkr.ecr.ap-south-1.amazonaws.com/himanshu/sentiment-analysis:latest

# Check if the container 'sentiment-app' is running
if [ "$(docker ps -q -f name=sentiment-app)" ]; then
    # Stop the running container
    docker stop sentiment-app
fi

# Check if the container 'sentiment-app' exists (stopped or running)
if [ "$(docker ps -aq -f name=sentiment-app)" ]; then
    # Remove the container if it exists
    docker rm sentiment-app
fi

# Run a new container
docker run -d -p 80:8000 -e DAGSHUB_PAT=0ef3c3cf116088b430021d284c67ca283918b7ea --name sentiment-app 891377050051.dkr.ecr.ap-south-1.amazonaws.com/himanshu/sentiment-analysis:latest
