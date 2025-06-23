#!/bin/bash

# GCP n8n Deployment Script
# Usage: ./deploy-gcp.sh

set -e

# Configuration
PROJECT_ID="bitgrit-demos"
REGION="asia-northeast1"
SERVICE_NAME="n8n-service"
IMAGE_NAME="n8n"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting n8n deployment to GCP Cloud Run${NC}"

# Source gcloud path first
source ~/google-cloud-sdk/path.bash.inc

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}gcloud CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Set project
echo -e "${YELLOW}Setting GCP project to ${PROJECT_ID}${NC}"
gcloud config set project $PROJECT_ID

# Enable required APIs
echo -e "${YELLOW}Enabling required APIs...${NC}"
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com

# Generate encryption key if not set
if [ -z "$N8N_ENCRYPTION_KEY" ]; then
    N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
    echo -e "${YELLOW}Generated encryption key: $N8N_ENCRYPTION_KEY${NC}"
    echo -e "${YELLOW}Please save this key securely!${NC}"
fi

# Build and deploy using Cloud Build
echo -e "${YELLOW}Building and deploying with Cloud Build...${NC}"
gcloud builds submit --config=cloudbuild.yaml \
    --substitutions=_N8N_ENCRYPTION_KEY="$N8N_ENCRYPTION_KEY"

# Get service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format='value(status.url)')

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}Service URL: $SERVICE_URL${NC}"
echo -e "${YELLOW}Encryption Key: $N8N_ENCRYPTION_KEY${NC}"
echo -e "${YELLOW}Please save the encryption key securely for future use.${NC}"

# Optional: Open in browser
read -p "Open n8n in browser? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$SERVICE_URL" || xdg-open "$SERVICE_URL" || echo "Please open $SERVICE_URL in your browser"
fi