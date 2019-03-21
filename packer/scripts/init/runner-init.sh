#!/bin/bash

function die (){
  echo "$1" 1>&2
  exit 1
}

echo "- Updating package list"
sudo apt-get update -y
[ $? -ne 0 ] && die "Failed to update";

echo "- Downloading gitlab package"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
[ $? -ne 0 ] && die "Failed to download";

echo "- Installing gitlab package"
sudo apt-get update -y
sudo apt-get install gitlab-runner -y
[ $? -ne 0 ] && die "Failed to install";

echo "- Installing docker"
curl -sSL https://get.docker.com/ | sh
[ $? -ne 0 ] && die "Failed to install docker";

echo "- Giving gitlab-runner ability to use docker"
sudo usermod -aG docker gitlab-runner
[ $? -ne 0 ] && die "Failed to give gitlab-runner ability to use docker";

echo "- Installing docker-machine"
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
docker-machine version
[ $? -ne 0 ] && die "Failed to install docker machine";

echo "Gitlab Register script"
sudo mv /tmp/gitlab_register.sh /opt/runner-init.sh
sudo chmod +x /opt/runner-init.sh
[ $? -ne 0 ] && die "Failed to move init script";

echo "Image Built Successfully"
exit 0
