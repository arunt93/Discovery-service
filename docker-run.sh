#!/bin/bash

# Build the image
docker build -t discovery-server .

# Stop existing container if running
docker stop discovery-server 2>/dev/null
docker rm discovery-server 2>/dev/null

# Run the container
docker run -d \
  --name discovery-server \
  -p 8761:8761 \
  -e SPRING_PROFILES_ACTIVE=docker \
  discovery-server

echo "Discovery server is running on http://localhost:8761"
echo "Check logs with: docker logs -f discovery-server"
