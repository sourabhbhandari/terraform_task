output "id" {
  value       = aws_vpc.default.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "private subnet IDs"
}

output "ubuntu_hostname" {
  value       = aws_instance.ubuntu_instance.public_dns
  description = "Public DNS or IP of Launched Instance"
}

output "ubuntu_instance_sg_id" {
  value       = aws_security_group.ubuntu_instance_sg.id
  description = "Security Group ID attached to Ubuntu instance"
}

output "ubuntu_network_interface_id" {
  value       = aws_instance.ubuntu_instance.primary_network_interface_id
  description = "network interface id"
}

output "cidr_block" {
  value       = var.cidr_block
  description = "CIDR block for VPC"
}

output "nat_gateway_ips" {
  value       = aws_eip.nat.*.public_ip
  description = "Elastic IPs associated with NAT gateways"
}