#!/bin/bash
#!/bin/bash
set -x
source /etc/lsb-release

export  DEBIAN_FRONTEND="noninteractive" 

# Install Java 

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y 

# Install Jenkins 
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y

sudo systemctl start jenkins
