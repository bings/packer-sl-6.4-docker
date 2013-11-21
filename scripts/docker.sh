#!/bin/bash

# disable firewall
service iptables stop
chkconfig iptables off

# enable IPv4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

# disable SELINUX
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

# add repositories
yum -y install wget
yum -y install http://ftp.riken.jp/Linux/fedora/epel/6/i386/epel-release-6-8.noarch.rpm

cd /etc/yum.repos.d
wget http://www.hop5.in/yum/el6/hop5.repo

# this is needed so that the VM guest additions can be build
yum -y install docker-io
yum -y install kernel-ml-aufs-devel kernel-ml-aufs-headers

# use 3.10 kernel by default
sed -i "s/default=1/default=0/" /boot/grub/grub.conf

# mount cgroups on startup
echo "none                    /sys/fs/cgroup          cgroup  defaults        0 0" >> /etc/fstab

# reboot
echo "Rebooting the machine..."
reboot
sleep 60
