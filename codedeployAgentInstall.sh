#!/bin/bash
sudo yum update
sudo yum install ruby -y
sudo yum install wget -y
yum install -y git
sudo yum install java-17-amazon-corretto-devel -y
cd /home/ec2-user
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
echo "root:newpassword12!@" | chpasswd
