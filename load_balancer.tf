resource "aws_lb" "my_cool_alb" {
  name               = "cool-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cool_sg_lb.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]

  enable_deletion_protection = false
  tags = merge({ Name = "CoolALB"}, var.common_tags)
}

resource "aws_lb_target_group" "cool_alb_target_group" {
  name                 = "cool-alb-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = data.aws_vpc.default_vpc.id
  deregistration_delay = 30

  health_check {
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    path                = "/"
    matcher             = "200,202" 
  }

  tags = merge({ Name = "CoolTG" }, var.common_tags)
}

resource "aws_lb_listener" "cool_alb_listener" {
  load_balancer_arn = aws_lb.my_cool_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.cool_alb_target_group.arn
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_azs.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available_azs.names[1]
}
