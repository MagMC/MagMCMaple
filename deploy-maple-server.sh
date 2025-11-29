#!/bin/bash

# Script to build and deploy Cosmic MapleStory server on Raspberry Pi 4

set -e  # Exit on any error

echo "Starting MySQL database container..."
docker rm -f cosmic-db 2>/dev/null || true
docker run -d \
  --name cosmic-db \
  -e MYSQL_DATABASE=cosmic \
  -e MYSQL_ROOT_PASSWORD=1234 \
  -p 3306:3306 \
  -v /media/plex-drive/docker/maplestory_server/database:/var/lib/mysql \
  mysql:8.4.0

echo "Waiting for MySQL to be ready..."
sleep 10

echo "Building Docker image..."
docker build -f DockerfileRpi4 -t cosmic-server .

echo "Stopping and removing old container (if exists)..."
docker rm -f cosmic-server 2>/dev/null || true

echo "Starting new container..."
docker run -d \
  --name cosmic-server \
  -p 8484:8484 \
  -p 7575:7575 \
  -p 7576:7576 \
  -p 7577:7577 \
  cosmic-server

echo "Container started successfully!"
echo "Showing logs (Ctrl+C to exit)..."
echo "-----------------------------------"
docker logs -f cosmic-server