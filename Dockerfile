# Use official Terraform image
FROM hashicorp/terraform:1.8.0

# Set working directory inside container
WORKDIR /workspace

# Copy all Terraform configs from repo
COPY . .

# Optional: install AWS CLI if needed for validation or scripting
RUN apk add --no-cache bash curl unzip \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip && ./aws/install \
    && rm -rf awscliv2.zip aws/

# Initialize Terraform
RUN terraform init

# Validate Terraform configs
RUN terraform validate

# Optional: show plan (for debugging or audit)
RUN terraform plan -out=tfplan

