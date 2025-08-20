# Use official Terraform image
FROM hashicorp/terraform:1.8.0

# Set working directory inside container
WORKDIR /workspace

# Copy all Terraform configs from repo
COPY . .



# Initialize Terraform
RUN terraform init

# Validate Terraform configs
RUN terraform validate
