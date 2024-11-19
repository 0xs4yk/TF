resource "aws_lb" "MLE-LoadBalancer" {
  name               = "MLE-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0c925a867a4bd98bf"]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "MLE-TargetGroup" {
  name     = "MLE-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_launch_template" "MLE-LaunchTemplate" {
  name          = "MLE-LaunchTemplate"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOT
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Instance ID: $(curl http://169.254.169.254/latest/meta-data/instance-id)" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
            EOT
  )

  key_name = "MLE-KeyPair"
  
  tags = {
    Name = "MLE_Instance"
  }
}

resource "aws_autoscaling_group" "MLE-AutoScalingGroup" {
  desired_capacity     = var.desired_capacity
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    id      = aws_launch_template.MLE-LaunchTemplate.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.MLE-TargetGroup.arn]
}

resource "aws_lb_listener" "MLE-LoadBalancerListener" {
  load_balancer_arn = aws_lb.MLE-LoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.MLE-TargetGroup.arn
  }
}
