#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT="$( cd $DIR && cd .. && pwd)"
SCRIPTS=$ROOT/scripts

sudo kubeadm reset --cri-socket=unix://run/containerd/containerd.sock -f

ifconfig -a | grep _tap | cut -f1 -d":" | while read line ; do sudo ip link delete "$line" ; done
ifconfig -a | grep tap_ | cut -f1 -d":" | while read line ; do sudo ip link delete "$line" ; done
bridge -j vlan |jq -r '.[].ifname'| while read line ; do sudo ip link delete "$line" ; done

rm ${HOME}/.kube/config
sudo rm -rf ${HOME}/tmp