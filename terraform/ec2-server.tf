resource "aws_instance" "szotowicz-ec2-server-a" {
  ami                         = "ami-06672d07f62285d1d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.szotowicz-ups007-key.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.szotowicz-subnet-server-a.id
  vpc_security_group_ids      = [
    aws_security_group.szotowicz-allow-ssh-internal.id,
    aws_security_group.szotowicz-allow-http-internal.id,
    aws_security_group.szotowicz-allow-all-outbound.id
  ]

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install nodejs -y
sudo yum install git -y
git clone https://github.com/szotowicz/pgs-upskill-aws1.git
cd pgs-upskill-aws1/ups-server/
sudo npm install -g serve
sudo npm install -g pm2
sudo npm install
echo 'DB_HOST=${aws_db_instance.szotowicz-rds.address}
DB_USER=${var.db-username}
DB_PASSWORD=${var.db-password}
DB_NAME=${var.db-name}
DB_TABLE_NAME=${var.db-table-name}' >> .env
sudo chown -R $USER:$USER .env
EOF

  tags = {
    Name = "szotowicz-ec2-server-a"
    Owner = "mszotowicz"
  }
}