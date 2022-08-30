#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

echo "dir: " $DIR
echo "root: " $ROOT
echo "scripts: " $SCRIPTS

#! Disable swap
sudo swapoff -a
#! Keeps the swap off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#! Disable auto updates for the system:
echo "Disabling auto updates..."
$SCRIPTS/disable_auto_updates.sh

echo "Installing necessary software dependencies..."
#! Install necessary software dependencies:
$SCRIPTS/install_dependencies.sh

#! Install K8s components:
echo "Installing K8s components and configurations..."
$SCRIPTS/install_k8s_components.sh

#! Set up kubelet:
echo "Setting up kubelet..."
$SCRIPTS/setup_kubelet.sh
