output "vpc-id" {
  description = "The ID of created VPC"
  value       = aws_vpc.mszotowicz-vpc.id
}

output "eip-public-ip" {
  description = "The public IP address of allocate Elastic IP address"
  value       = aws_eip.szotowicz-eip.public_ip
}

output "ec2-client-public-dns" {
  description = "The public DNS address of created ups-client"
  value       = aws_instance.szotowicz-ec2-client-a.public_dns
}

output "ec2-client-public-ip" {
  description = "The public IP address of created ups-client"
  value       = aws_instance.szotowicz-ec2-client-a.public_ip
}

output "ec2-server-private-ip" {
  description = "The private IP address of created ups-server"
  value       = aws_instance.szotowicz-ec2-server-a.private_ip
}

output "rds-address" {
  description = "The private IPv4 address of created RDS"
  value       = aws_db_instance.szotowicz-rds.address
}
