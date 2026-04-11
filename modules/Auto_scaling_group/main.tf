resource "aws_autoscaling_group" "asg" {
  name = "ASG"
  vpc_zone_identifier = [var.asg_subnet]
  min_size = 1
  max_size = 4
  desired_capacity = 4
  target_group_arns = [var.target_group_arn]
  launch_template {
    id = var.tmp_id
    version = "$Latest"
  }
}

