resource "aws_alb" "alb" {
  load_balancer_type = "application"
  name = "load-balancer"
  subnets = var.subnet_ids
  security_groups = [var.security_group]
}

resource "aws_lb_target_group" "target_group" {
  target_type = "instance"
  name = "Target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
  }
}

# resource "aws_lb_target_group_attachment" "instance_tga" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id = 
#   port = 80
# }

resource "aws_lb_listener" "lb_listener" {
  port = 80
  protocol = "HTTP"
  load_balancer_arn = aws_alb.alb.arn
  default_action  {
  type = "forward"
  target_group_arn = aws_lb_target_group.target_group.arn
  }
}
