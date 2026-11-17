output "debian_ami_used" {
  description = "The Debian AMI ID fetched for ap-southeast-2"
  value       = data.aws_ami.debian.id
}

output "web_server_id" {
  description = "Instance ID of the Web Server"
  value       = module.web_server.instance_id
}

output "web_server_public_ip" {
  description = "Public IP of the Web Server"
  value       = module.web_server.public_ip
}

output "app_server_id" {
  description = "Instance ID of the App Server"
  value       = module.app_server.instance_id
}

output "app_server_public_ip" {
  description = "Public IP of the App Server"
  value       = module.app_server.public_ip
}
