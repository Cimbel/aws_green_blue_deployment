resource "aws_launch_template" "demo_lt" {
  name_prefix            = "Demo-Cool-LT-"
  image_id               = data.aws_ami.amazon_linux_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cool_sg_asg.id]
  user_data              = filebase64("user_data_lt.sh")
  update_default_version = true
  key_name               = aws_key_pair.dev_key.key_name

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({ Name = "MyCoolLT" }, var.common_tags)
}

resource "aws_key_pair" "dev_key" {
  key_name = "cool_key"
  public_key = file(var.ssh_pub_key_path)
}
