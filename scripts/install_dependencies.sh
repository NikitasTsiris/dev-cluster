#! /bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

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
echo "${BGreen}Installing Go...${Color_Off}"
set -e
wget --continue --quiet https://golang.org/dl/go1.18.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
sudo sh -c  "echo 'export PATH=\$PATH:/usr/local/go/bin' >> /etc/profile"
source /etc/profile
rm go1.18.linux-amd64.tar.gz

# Install Helm:
echo "${BGreen}Installing Helm...${Color_Off}"
curl --silent --show-error -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Install Dependencies for Social Network Microservice Benchmark
echo "${BGreen}Installing python and dependencies for SocialNetwork benchmark...${Color_Off}"
sudo apt-get -y install \
    python3 \
    python3-pip \
    libssl-dev \
    libz-dev \
    luarocks >> /dev/null

pip3 install asyncio >> /dev/null
pip3 install aiohttp >> /dev/null
sudo luarocks install luasocket >> /dev/null