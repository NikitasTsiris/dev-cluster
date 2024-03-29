#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && cd .. && pwd)"
SCRIPTS=$ROOT/scripts/utils

echo -e "${BGreen}dir: ${Color_Off}" $DIR
echo -e "${BGreen}root: ${Color_Off}" $ROOT
echo -e "${BGreen}scripts: ${Color_Off}" $SCRIPTS

#! Disable swap
echo -e "${BGreen}Disabling swap in the system across reboots...${Color_Off}"
sudo swapoff -a
#! Keeps the swap off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo -e "${BGreen}Disabling swap DONE${Color_Off}"

#! Disable auto updates for the system:
echo -e "${BGreen}Disabling auto updates...${Color_Off}"
$SCRIPTS/disable_auto_updates.sh
echo -e "${BGreen}Disabling auto updates DONE${Color_Off}"

echo -e "${BGreen}Installing necessary software dependencies...${Color_Off}"
#! Install necessary software dependencies:
$SCRIPTS/install_dependencies.sh
echo -e "${BGreen}Installing Dependencies DONE${Color_Off}"

#! Install K8s components:
echo -e "${BGreen}Installing K8s components and configurations...${Color_Off}"
$SCRIPTS/install_k8s_components.sh
echo -e "${BGreen}K8s Components DONE${Color_Off}"


#! Set up kubelet:
echo -e "${BGreen}Setting up kubelet...${Color_Off}"
$SCRIPTS/setup_kubelet.sh
echo -e "${BGreen}Kubelet Setup DONE${Color_Off}"
