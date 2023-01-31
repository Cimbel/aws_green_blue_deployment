resource "aws_autoscaling_group" "my_cool_asg" {
  name                      = "ASG-${aws_launch_template.demo_lt.name_prefix}"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.cool_alb_target_group.arn]
  vpc_zone_identifier       = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  min_elb_capacity          = 2
  default_cooldown          = 60
  health_check_grace_period = 60

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      target_group_arns
    ]
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  launch_template {
    id      = aws_launch_template.demo_lt.id
    version = aws_launch_template.demo_lt.latest_version
  }

}

resource "aws_autoscaling_policy" "target_tracking_asg_policy" {
  name                        = "cpu-scaling-target-policy"
  policy_type                 = "TargetTrackingScaling"
  estimated_instance_warmup   = 60
  autoscaling_group_name      = aws_autoscaling_group.my_cool_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}
