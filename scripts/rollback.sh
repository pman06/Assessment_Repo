#!/bin/bash


NAMESPACE="app-ns"
DEPLOYMENT="prod-app"
CONTAINER_NAME="production-deployment"
IMAGE_REPO="pman06/app"

echo "⚙️ Rolling back deployment '$DEPLOYMENT' in namespace '$NAMESPACE'..."

# Step 1: Rollback to previous ReplicaSet
kubectl rollout undo deployment/$DEPLOYMENT -n $NAMESPACE

# Step 2: Get the new (rolled-back) image
ROLLED_BACK_IMAGE=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o=jsonpath="{.spec.template.spec.containers[?(@.name==\"$CONTAINER_NAME\")].image}")

echo "✅ Rolled back to image: $ROLLED_BACK_IMAGE"

# Step 3: Optional - Monitor rollout status
echo "⏳ Waiting for deployment to become ready..."
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE

# Step 4: Optional - Show current replicas and pods
kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT

echo "✅ Rollback completed."
