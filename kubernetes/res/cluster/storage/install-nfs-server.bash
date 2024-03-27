sudo apt update
sudo apt install nfs-kernel-server

sudo mkdir -p /opt/nfs
sudo echo /opt/nfs    192.168.178.0/24(rw,sync,no_subtree_check,fsid=0)> /etc/exports
sudo exportfs -a