resource "aws_instance" "bastion" {
  ami = "ami-8ff710e2"
  instance_type = "t1.micro"
  key_name = "${aws_key_pair.root_key.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
    "${aws_security_group.public.id}"
  ]
  subnet_id = "${aws_subnet.zone_b.id}"
  associate_public_ip_address = true
  tags {
    Name = "${var.environment}-${var.project}-bastion-instance"
    type = "ec2-instance"
    project = "${var.project}"
    environment = "${var.environment}"
  }
}
