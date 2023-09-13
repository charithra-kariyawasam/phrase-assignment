#!/bin/bash

####Setup Repos required to install ansible####
apt-add-repository ppa:ansible/ansible
apt update

####Install Ansible####
apt install ansible

##### Install Docker ######
###########################

##### Installin the pre-requsites ######
apt install apt-transport-https ca-certificates curl software-properties-common

##### Add the GPG Key #####
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

##### Add the docker repository for apt packages #####
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

##### Execute the apt update #####
apt update

###### Check the wether it is the docker-ce repo or the default one for ubuntu #####
apt-cache policy docker-ce

###### Install docker repo #####
apt install docker-ce


##### Install Kubernetes #####
##############################

##### kubectl installation #####
apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl

##### Install minikube #####
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

##### start minikube #####
minikube start --force

#### Configure Docker to use the Docker daemon #####
eval $(minikube docker-env)

