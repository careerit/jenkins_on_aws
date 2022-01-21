#!/bin/bash
#!/bin/bash
set -x
source /etc/lsb-release

export  DEBIAN_FRONTEND="noninteractive" 

# Install Java 

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y 

sudo useradd -d /var/lib/jenkins jenkins


sudo apt-get install maven -y
