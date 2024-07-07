resource "aws_security_group" "my_sg" {
  depends_on = [ aws_vpc.my_vpc ]
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_template" "my_lt" {
  image_id        = var.ubuntu_image
  instance_type   = var.instance_type
  user_data       = file("user-data.sh")
  
  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.my_sg.id]
  }
}

resource "aws_autoscaling_group" "my_asg" {
  depends_on = [ aws_launch_configuration.my_lc ]
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.my_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "my-instance"
    propagate_at_launch = true
  }
}
