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

# Dynamically fetch the latest official Debian 12 AMI in ap-southeast-2
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"] # Official Debian AWS Account ID

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Deploy First Debian EC2 Instance
module "web_server" {
  source = "./modules/ec2"

  ami_id        = data.aws_ami.debian.id
  instance_type = var.web_instance_config.instance_type
  instance_name = var.web_instance_config.instance_name

  tags = {
    Environment = "Production"
    OS          = "Debian-12"
  }
}

# Deploy Second Debian EC2 Instance with a different configuration
module "app_server" {
  source = "./modules/ec2"

  ami_id        = data.aws_ami.debian.id
  instance_type = var.app_instance_config.instance_type
  instance_name = var.app_instance_config.instance_name

  tags = {
    Environment = "Staging"
    OS          = "Debian-12"
  }
}
