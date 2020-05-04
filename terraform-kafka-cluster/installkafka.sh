#!/bin/bash

export PASS=ansible
useradd -p $(openssl passwd -1 $PASS) ansible

sudo yum update -y
sudo yum install java-1.8.0-openjdk -y
sudo amazon-linux-extras install ansible2 -y

sudo wget http://www-us.apache.org/dist/kafka/2.4.0/kafka_2.13-2.4.0.tgz
sudo tar xvzf kafka_2.13-2.4.0.tgz -C /home/ansible
sudo mv /home/ansible/kafka_2.13-2.4.0 /home/ansible/kafka

sudo rm -rf kafka_2.13-2.4.0.tgz

sudo mkdir -p /home/ansible/.ssh
sudo touch /home/ansible/.ssh/authorized_keys
sudo mkdir -p /home/ansible/zookeeper/data
sudo touch /home/ansible/zookeeper/data/myid
sudo chmod 755 /home/ansible/zookeeper/data/myid
sudo chown -R ansible:ansible ansible
sudo touch /tmp/kafka-logs
sudo chown ansible:ansible /tmp/kafka-logs
sudo chmod 600 /tmp/kafka-logs

sudo echo -e "ansible ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo service sshd restart

function install_zookeeper() {
        zookeeperfile=/etc/systemd/system/zookeeper.service
        if [ ! -f $zookeeperfile ]
        then
                touch $zookeeperfile
        else
                > $zookeeperfile
        fi

        echo '
[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target
After=network.target remote-fs.target
[Service]
Type=simple
ExecStart=/home/ansible/kafka/bin/zookeeper-server-start.sh /home/ansible/kafka/config/zookeeper.properties
ExecStop=/home/ansible/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal
[Install]
WantedBy=multi-user.target
        ' > /etc/systemd/system/zookeeper.service
        sudo systemctl daemon-reload
}

function install_kafka() {
        kafkafile=/etc/systemd/system/kafka.service
        if [ ! -f $kafkafile ]
        then
                touch $kafkafile
        else
                > $kafkafile
        fi

        echo '
[Unit]
Description=Apache Kafka Server
Documentation=http://kafka.apache.org/documentation.html
Requires=zookeeper.service
[Service]
Type=simple
Environment="JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.amzn2.0.1.x86_64"
ExecStart=/home/ansible/kafka/bin/kafka-server-start.sh /home/ansible/kafka/config/server.properties
ExecStop=/home/ansible/kafka/bin/kafka-server-stop.sh
[Install]
WantedBy=multi-user.target
        ' > /etc/systemd/system/kafka.service
        sudo systemctl daemon-reload
}

install_zookeeper
install_kafka
