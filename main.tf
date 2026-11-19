terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Fetch latest official Debian 12 AMI in ap-southeast-2
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Register your local public SSH key in AWS
resource "aws_key_pair" "deployer" {
  key_name   = "week7-docker-key"
  public_key = file(pathexpand(var.public_key_path))
}

# Security Group to allow SSH and Application Access via Public IP
resource "aws_security_group" "docker_app_sg" {
  name        = "week7-docker-app-sg"
  description = "Allow SSH and web traffic to Docker EC2 instance"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Debian EC2 Instance and install Docker + Docker Compose
resource "aws_instance" "docker_host" {
  ami                    = data.aws_ami.debian.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.docker_app_sg.id]

  # Step 2: Automatically install Git, Docker, and Docker Compose plugin on Debian
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y ca-certificates curl gnupg git
              install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://docker.com | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              chmod a+r /etc/apt/keyrings/docker.gpg
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              usermod -aG docker admin
              systemctl enable --now docker
              EOF

  tags = {
    Name = "Week7-Docker-EC2"
  }
}
