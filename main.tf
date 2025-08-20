provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "yuga" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "yuga-unique-bucket-name"  # Make sure this name is globally unique
  tags = {
    Name = "yuga"
  }
}

