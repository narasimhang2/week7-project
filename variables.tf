variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "Free Tier eligible EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Path to your local SSH public key"
  type        = string
  default     = "~/.ssh/week7-docker-key.pub"
}

variable "app_port" {
  description = "Port your Docker application listens on"
  type        = number
  default     = 80
}
