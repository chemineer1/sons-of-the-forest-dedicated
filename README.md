# 🌲 Dockerized Sons of the Forest Server on Linux  🌲

Host your own Sons of the Forest dedicated server on Linux. Easily deploy with Docker 🐳.

## 🛖 Description

With this repo, you can host your own Sons of the Forest dedicated server on a linux machine. It uses Wine 🍷, because the game server is written for Windows, and the xserver-xorg-video-dummy driver so that it can run headless (without display, mouse, or keyboard). The whole thing is packaged in a Docker image so it's easy to deploy.

## 🪓 Prerequisites

1. Set up a Linux machine. I recommend a **t3.xlarge** EC2 instance on AWS, running Amazon Linux.
2. Install [Docker Engine](https://docs.docker.com/engine/install/).
3. Enable Docker Engine to start on sign in. For example
```
sudo systemctl enable docker
sudo systemctl start docker
```
4. Install [Docker Compose](https://docs.docker.com/compose/install/).
5. Optionally add yourself to the **docker** user group so you can use Docker commands without `sudo`. You will have to log out and back in for the change to take effect.

## 🏹 Installation

- git clone the repo onto your Linux machine and `cd` into it. The first time you start the server, it will download the Docker image. If you want to build the image yourself, see the configuration section below.

## 🛠️ Configuration

1. Create a new directory in the repo's root directory called **userdata**. This folder will remain even if you remove the container and it holds the saved game data.
2. In **userdata**, create two files called **dedicatedserver.cfg** and **ownerswhitelist.txt**. Write configuration data into these files according to the example files provided in this repo, and the [configuration guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2992700419&snr=). At a minimum, you should set the server name and password.
3. You may want to build your own image to get the latest game updates. In that case open **docker-compose.yml**, comment out the first `image` element and uncomment the second `image` element.

## 🧟 Usage

### Starting the game server

Run `docker compose up` or `docker compose up -d` in the repo root directory. This will start the container using the configuration in the **docker-compose.yml** file. The container is configured to start automatically when the computer boots up.

### Stopping the game server

If your shell is attached to the docker container, use the CTRL+C keyboard interrupt to gracefully stop the server. If the container is running in the background, run `docker compose stop` instead. You can also just gracefully shutdown your computer to stop the server. Docker will receive a shutdown signal and it will pass it to the Docker container.

### Updating the game server

If you are pulling a new image from Docker Hub...
```
docker compose down
git pull origin main
docker pull chemineer/sons-of-the-forest:latest
docker compose up
```
If you are building the image yourself...
```
docker compose down
git pull origin main
docker build --no-cache -t chemineer/sons-of-the-forest .
docker compose up
```

## 🩸 Troubleshooting

### Ports

Make sure you open ports **8766**, **27016**, and **9700**. Also your router must be configured to forward the ports.

### Wine Assertion Error

You might occassionally see the following error in the console when starting the server
```
wineserver: server/fd.c:1622: set_fd_events: Assertion 'poll_users[user] == fd' failed.
```
If this occurs, simply `docker compose stop` or `docker compose down` and then bring it back up. It does not seem to happen twice in a row.
