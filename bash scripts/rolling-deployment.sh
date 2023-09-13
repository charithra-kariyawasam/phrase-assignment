#!/bin/bash

# Define variables
APP_NAME="flask-api"
NEW_IMAGE_TAG="new-version"
DEPLOYMENT_NAME="flaskapi-deployment"
DOCKER_IMAGE="$APP_NAME:$NEW_IMAGE_TAG"

# Build and push the new Docker image to your registry
echo "Building and pushing the new Docker image..."
docker build -t "$DOCKER_IMAGE" -f ../application/Dockerfile .

# Update the Kubernetes deployment to use the new image
echo "Updating the Kubernetes deployment..."
kubectl set image ../kubernetes/"$DEPLOYMENT_NAME" "$APP_NAME=$DOCKER_IMAGE"

# Monitor the rollout status
echo "Monitoring rollout status..."
kubectl rollout status ../kubernestes/"$DEPLOYMENT_NAME"

echo "Deployment complete!"