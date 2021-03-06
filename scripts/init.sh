#!/bin/bash

set -e

#config user
#echo '=========> recreate user roar'
#userdel  roar  2>&1
#groupdel roar  2>&1
#useradd -p $(openssl passwd -1 5iroar) -u 3001 -s /bin/bash -m roar

#usermod -aG docker roar
#set ssh 
echo '=========> add ssh configuration for user roar'
mkdir -p /home/roar/.ssh
#setup ssh
SSH_DIR=/home/roar/.ssh
mv /tmp/id_rsa $SSH_DIR/id_rsa
mv /tmp/id_rsa.pub $SSH_DIR/id_rsa.pub
cat $SSH_DIR/id_rsa.pub > $SSH_DIR/authorized_keys
chmod 0771 $SSH_DIR
chmod 0600 $SSH_DIR/id_rsa
chown -R roar:roar /home/roar

#create application directory
echo '=========> create apps directory'
mkdir -p /opt/apps
chown -R roar:roar /opt/apps
mkdir -p /data/roar
chown -R roar:roar /data/roar

echo '=========> config openssh server'
sed -i s'/^UseDNS/#UseDNS/g' /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
service ssh reload

#config apt
echo '=========> upgrade system'
export DEBIAN_FRONTEND=noninteractive
mv sources.list /etc/apt/
apt-get update
dpkg --remove-architecture i386
apt-get -y --force-yes purge ubuntu-desktop ubuntu-standard  libice6 unity* language-pack* build-essential firefox*
apt-get -y autoremove
sync
apt-get -q -yy upgrade
apt-get -yy -q --force-yes install git-core

#cofig locale
echo '=========> config locale'
echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen
locale-gen --purge zh_CN.UTF-8
update-locale LANG=zh_CN.UTF-8
echo 'LC_ALL=zh_CN.UTF-8' >> /etc/environment
echo 'LANG=zh_CN.UTF-8' >> /etc/environment
echo 'Asia/Shanghai' > /etc/timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#apt-get -y install numactl
echo '=========> disable ipv6'
#config ipv6
echo 'net.ipv6.conf.all.disable_ipv6=1' > /etc/sysctl.d/60-disable-ipv6.conf
echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.d/60-disable-ipv6.conf
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.d/60-disable-ipv6.conf
sysctl -p > /tmp/l.txt

#config user limit 
echo '=========> set user limits '
sed -i s'/^roar.*$//g' /etc/security/limits.conf
echo 'roar  -       nofile  32768' >> /etc/security/limits.conf
echo 'roar  -       nproc   32000' >> /etc/security/limits.conf



#config docker registry

#sed -i s'/^DOCKER_OPTS/#DOCKER_OPTS/g' /etc/default/docker
#echo "DOCKER_OPTS=\"--insecure-registry ${DOCKER_REGISTRY}\"" >> /etc/default/docker
#service docker restart


#config sudo 
echo '=========> set user roar sudo '
mv roar_sudo /etc/sudoers.d/
chown root:root /etc/sudoers.d/roar_sudo
chmod 440 /etc/sudoers.d/roar_sudo

#reboot

