resource "aws_instance" "szotowicz-ec2-client-a" {
  ami                         = "ami-06672d07f62285d1d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.szotowicz-ups007-key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.szotowicz-subnet-client-a.id
  vpc_security_group_ids      = [
    aws_security_group.szotowicz-allow-ssh-owner.id,
    aws_security_group.szotowicz-allow-http-public.id,
    aws_security_group.szotowicz-allow-all-outbound.id
  ]

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install nodejs -y
sudo yum install git -y
git clone https://github.com/szotowicz/pgs-upskill-aws1.git
cd pgs-upskill-aws1/
echo '${file("./szotowicz-priv.pem")}' >> ec2.pem
cd ups-client/
sudo npm install -g serve
sudo npm install -g pm2
sudo npm install -g yarn
sudo yarn install
sudo yarn build
sudo pm2 serve build 80 --spa
EOF

  tags = {
    Name = "szotowicz-ec2-client-a"
    Owner = "mszotowicz"
  }
}