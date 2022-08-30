#!/bin/bash

sudo rm -f /etc/apt/apt.conf.d/20auto-upgrades
sudo tee /etc/apt/apt.conf.d/99auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

# Disable the systemd timers that schedule the apt updates/upgrades
# Source: https://saveriomiroddi.github.io/Handling-the-apt-lock-on-ubuntu-server-installations/#comment-5277734269
sudo systemctl stop apt-daily.timer apt-daily-upgrade.timer
sudo systemctl mask apt-daily.service apt-daily-upgrade.service
sudo systemctl kill --kill-who=all apt-daily.service
sudo rm -f /var/lib/systemd/timers/stamp-apt-daily.timer
sudo rm -f /var/lib/systemd/timers/stamp-apt-daily-upgrade.timer

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | egrep -q '(dead|failed)')
do
  sleep 1
done

# Source: https://askubuntu.com/a/375031/388226
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 1
done
