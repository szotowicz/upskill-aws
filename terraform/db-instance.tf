resource "aws_db_instance" "szotowicz-rds" {
  identifier             = "szotowicz-rds"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = var.db-username
  password               = var.db-password
  db_name                = var.db-name
  db_subnet_group_name   = aws_db_subnet_group.szotowicz-rds-sg.name
  apply_immediately      = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [
    aws_security_group.szotowicz-allow-db-internal.id,
    aws_security_group.szotowicz-allow-all-outbound.id
  ]

  tags = {
    Name = "szotowicz-rds"
    Owner = "mszotowicz"
  }
}