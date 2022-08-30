#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

echo "dir: " $DIR
echo "root: " $ROOT
echo "scripts: " $SCRIPTS

#! Disable auto updates for the system:
$SCRIPTS/disable_auto_updates.sh

#! Install necessary software dependencies:
$SCRIPTS/install_dependencies.sh

#! Install K8s components:
$SCRIPTS/install_k8s_components.sh

#! Set up kubelet:
$SCRIPTS/setup_kubelet.sh
