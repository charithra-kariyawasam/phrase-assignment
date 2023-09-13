# Deploying a Flask API and MySQL Redis server on Kubernetes

This repo contains code that 
1) Deploys a MySQL server on a Kubernetes cluster
2) Attaches a persistent volume to it, so the data remains contained if pods are restarting
3) Deploys a Flask API with set of predefine APIs in the app.py
4) Setup a redis server and connects with Flask the Application
5) Ansible scripts to install required linux users and NGINX reverse proxy
6) Bash script to setup the server dependencies

## Prerequisites
1. Have a linux ubuntu22.04 server
2. Have `Docker` and the `Kubernetes CLI` (`kubectl`) installed together with `Minikube` (https://kubernetes.io/docs/tasks/tools/)

## Getting started
1. Clone the repository
2. Configure `Docker` to use the `Docker daemon` in your kubernetes cluster via your terminal: `eval $(minikube docker-env)`
3. Pull the latest mysql image from `Dockerhub`: `Docker pull mysql`
4. Build a kubernetes-api image with the Dockerfile in this repo: `Docker build . -t flask-api`

## Secrets
`Kubernetes Secrets` can store and manage sensitive information. For this example we will define a password for the
`root` user of the `MySQL` server using the `Opaque` secret type. For more info: https://kubernetes.io/docs/concepts/configuration/secret/

1. Encode your password in your terminal: `echo -n super-secret-passwod | base64`
2. Add the output to the `flakapi-secrets.yml` file at the `db_root_password` field

## Deployments-Initial
This is to setup the initial services and dependencies
1. Go to the `bash scripts` directory
2. Make the script an executable `chmod u+x server-setup-script.sh`
3. Make sure to provide `yes` answers according to the prompts

## Deployments-Linux User Setup
This will create the users with key based authetications
One user would be an admin user and other would be a user without sudo permissions.
1. Go to `ansible` directory
2. Execute `phrase-server-setup.yml` playbook: `ansible-playbook phrase-server-setup.yml`

## Deployment-Kubernetes Pods
Get the secrets, persistent volume in place and apply the deployments for the `MySQL` database and `Flask API`
1. Add the secrets to your `kubernetes cluster`: `kubectl apply -f flaskapi-secrets.yml`
2. Create the `persistent volume` and `persistent volume claim` for the database: `kubectl apply -f mysql-pv.yml`
3. Create the `MySQL` deployment: `kubectl apply -f mysql-deployment.yml`
4. Create the `Flask API` deployment: `kubectl apply -f flaskapp-deployment.yml`

You can check the status of the pods, services and deployments.

## Expose the API
The API can be accessed by exposing it using minikube: `minikube service flask-service`. The application is ready once the `/status` is responding with `200` message `OK`. Not ready state results in `404` message `Not ready`.

## Setting up the NGINX reverse proxy
1. Once you setup the minikube cluster get the minikube_url and minikube_ip using the following commands
`minikube service flask-service`
`minikube ip`
2. Use the output of them to update the vars requoired for the `nginx-proxy-setup` playbook. The vars file for this playbook is in `ansible/vars/nginx_vars.yml`
3. Execute the playbook `ansible-playbook nginx-proxy-setup.yml`
4. Create the developer user with `sudo htpasswd -c /etc/nginx/.htpasswd developer` command for the `basic-auth`. 

This reverse proxy will do the following
    * `/admin` endpoint is behind basic auth protection, create one user `developer` with some password
    * `/prepare-for-deploy` and `/ready-for-deploy` endpoint are blocked on load balancer and not available from the internet

## Rolling out deplyment using Kubernetes
This bash script is used to roll out the new flask app deployment without a downtime.
1. Go to `application`
2. Make the `rolling-deploymet.sh` an executable
3. Execute the script. This will setup additional pods with new image and terminate the old containers without affecting the uptime


