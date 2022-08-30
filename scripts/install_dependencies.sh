#! /bin/bash

 . /etc/os-release
sudo apt-get -y install curl ca-certificates >> /dev/null
sudo add-apt-repository -y universe >> /dev/null
sudo apt-get update >> /dev/null

sudo apt-get -y install \
    apt-transport-https \
    gcc \
    g++ \
    make \
    acl \
    net-tools \
    git-lfs \
    bc \
    gettext-base \
    jq \
    dmsetup \
    gnupg-agent \
    software-properties-common \
    iproute2 \
    nftables \
    git-lfs >> /dev/null

# Install Go
set -e

wget --continue --quiet https://golang.org/dl/go1.18.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

sudo sh -c  "echo 'export PATH=\$PATH:/usr/local/go/bin' >> /etc/profile"

# Install Dependencies for Social Network Microservice Benchmark
sudo apt-get -y install \
    python3 \
    libssl-dev \
    libz-dev \
    luarocks >> /dev/null

pip3 install asyncio
pip3 install aiohttp
sudo luarocks install luasocket