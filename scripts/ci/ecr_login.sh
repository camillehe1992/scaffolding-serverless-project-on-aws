#!/bin/bash
set -e -o pipefail

ECR_REGISTRY=$1

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
