#! /bin/bash

CRI_SOCK="/run/containerd/containerd.sock"

# Create kubelet service
sudo sh -c 'cat <<EOF > /etc/systemd/system/kubelet.service.d/0-containerd.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint='${CRI_SOCK}'"
EOF'
sudo systemctl daemon-reload