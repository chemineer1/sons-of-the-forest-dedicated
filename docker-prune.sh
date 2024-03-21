#!/bin/bash
# This will delete all containers, images, volumes, and cache. Everything.

docker rm -vf $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker volume rm $(docker volume ls -qf dangling=true)
docker system prune -a --volumes
