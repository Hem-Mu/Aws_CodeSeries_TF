#!/bin/bash
sudo yum update -y
yum install -y git
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-al2-jdk.rpm -O java17.rpm
sudo yum install java-17-amazon-corretto-devel -y
git clone https://github.com/Hem-Mu/Spring_demo3.git
cd Spring_demo3
chmod +x ./gradlew
./gradlew build
cd build/libs/
nohup java -jar helloboot-0.0.1-SNAPSHOT.jar &