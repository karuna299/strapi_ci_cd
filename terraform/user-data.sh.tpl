#!/bin/bash
set -e
sleep 20

# Install Docker & AWS CLI
apt-get update -y
apt-get install -y docker.io awscli

# Enable docker
systemctl enable --now docker

# Allow ubuntu user to run docker
usermod -aG docker ubuntu

# Login to ECR
aws ecr get-login-password --region ${region} \
  | docker login --username AWS --password-stdin $(echo ${ecr_image} | cut -d'/' -f1)

# Pull image
docker pull ${ecr_image}

# Run Strapi container with RDS values injected by Terraform
docker rm -f strapi || true
docker run -d -p 1337:1337 --name strapi \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=${db_endpoint} \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=${db_name} \
  -e DATABASE_USERNAME=${db_user} \
  -e DATABASE_PASSWORD=${db_pass} \
  -e DATABASE_SSL=true \
  -e DATABASE_SSL_REJECT_UNAUTHORIZED=false \
  -e ADMIN_JWT_SECRET="${admin_jwt_secret}" \
  -e API_TOKEN_SALT="${api_token_salt}" \
  -e APP_KEYS="${app_keys}" \
  ${ecr_image}
