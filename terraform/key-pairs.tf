resource "aws_key_pair" "szotowicz-ups007-key" {
  key_name   = "szotowicz-ups007-key"
  public_key = file("./szotowicz-pub.pem")

  tags = {
    Name = "szotowicz-ups007-key"
    Owner = "mszotowicz"
  }
}