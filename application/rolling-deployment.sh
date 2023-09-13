#!/bin/bash

# Define variables
APP_NAME="flaskapi"
NEW_IMAGE_TAG="latest22"
DEPLOYMENT_NAME="flaskapi-deployment"
DOCKER_IMAGE="flask-api:$NEW_IMAGE_TAG"

# Build and push the new Docker image to your registry
echo "Building and pushing the new Docker image..."
docker build -t "$DOCKER_IMAGE" .

# Update the Kubernetes deployment to use the new image
echo "Updating the Kubernetes deployment..."
kubectl set image deployment/"$DEPLOYMENT_NAME" "$APP_NAME=$DOCKER_IMAGE"

# Monitor the rollout status
echo "Monitoring rollout status..."
kubectl rollout status deployment/"$DEPLOYMENT_NAME"

echo "Deployment complete!"
