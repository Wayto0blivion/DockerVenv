#!/bin/bash

# update.sh - Script to manage packages in Docker container
# Usage: ./update.sh install <package-name>

# Exit on error
set -e

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check command line arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: ./update.sh install <package-name>"
    exit 1
fi

ACTION=$1
PACKAGE=$2

# Get the container name (assuming it's running)
CONTAINER_NAME=$(docker ps --filter "ancestor=python:3.10-slim" --format "{{.Names}}" | head -n 1)

if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: No running container found based on python:3.10-slim."
    echo "Make sure your Docker container is running."
    exit 1
fi

if [ "$ACTION" = "install" ]; then
    echo "Installing package: $PACKAGE"

    # Install the package in the container
    docker exec -it $CONTAINER_NAME pip install $PACKAGE

    # Update requirements.txt
    echo "Updating requirements.txt..."
    docker exec $CONTAINER_NAME pip freeze > requirements.txt

    # Rebuild the container
    echo "Rebuilding the container..."
    # Get the image name from the container
    IMAGE_NAME=$(docker inspect --format='{{.Config.Image}}' $CONTAINER_NAME)

    # Stop the container
    docker stop $CONTAINER_NAME

    # Rebuild the image
    docker build -t $IMAGE_NAME .

    echo "Done! Package $PACKAGE installed and container rebuilt."
    echo "You may need to restart your container or PyCharm to apply changes."
else
    echo "Unknown action: $ACTION"
    echo "Usage: ./update.sh install <package-name>"
    exit 1
fi
