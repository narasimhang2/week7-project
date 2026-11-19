output "instance_public_ip" {
  description = "Public IP of your Docker EC2 instance"
  value       = aws_instance.docker_host.public_ip
}

output "ssh_command" {
  description = "Command to connect to your Debian EC2 instance"
  value       = "ssh -i ~/.ssh/week7-docker-key admin@${aws_instance.docker_host.public_ip}"
}
