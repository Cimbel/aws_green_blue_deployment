resource "aws_security_group" "cool_sg_asg" {
  name        = "cool-sg-asg"
  description = "HTTP_SSH_ONLY"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    security_groups = [aws_security_group.cool_sg_lb.id]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
  }

  ingress {
    cidr_blocks = [var.my_ip_cidr]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks     = ["0.0.0.0/0"]
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
  }
}

resource "aws_security_group" "cool_sg_lb" {
  name        = "cool-sg-lb"
  description = "HTTP_ONLY_LB"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    cidr_blocks = [var.my_ip_cidr]
    protocol    = "tcp"
    to_port     = 80
    from_port   = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    to_port     = 0
    from_port   = 0
  }
}
