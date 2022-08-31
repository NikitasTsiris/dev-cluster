#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

# echo "${BGreen}dir: ${Color_Off}" $DIR
# echo "${BGreen}root: ${Color_Off}" $ROOT
# echo "${BGreen}scripts: ${Color_Off}" $SCRIPTS

#! Disable swap
echo "${BGreen}Disabling swap in the system across reboots...${Color_Off}"
sudo swapoff -a
#! Keeps the swap off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#! Disable auto updates for the system:
echo "${BGreen}Disabling auto updates...${Color_Off}"
$SCRIPTS/disable_auto_updates.sh

echo "${BGreen}Installing necessary software dependencies...${Color_Off}"
#! Install necessary software dependencies:
$SCRIPTS/install_dependencies.sh

#! Install K8s components:
echo "${BGreen}Installing K8s components and configurations...${Color_Off}"
$SCRIPTS/install_k8s_components.sh

#! Set up kubelet:
echo "${BGreen}Setting up kubelet...${Color_Off}"
$SCRIPTS/setup_kubelet.sh
