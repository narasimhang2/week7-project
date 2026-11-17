variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "web_instance_config" {
  description = "Configuration for the first EC2 instance (Web Server)"
  type = object({
    instance_type = string
    instance_name = string
  })
}

variable "app_instance_config" {
  description = "Configuration for the second EC2 instance (App Server)"
  type = object({
    instance_type = string
    instance_name = string
  })
}
