output "target_id" {
  value = aws_lb_target_group.target_group.id
}

output "alb_id" {
  value = aws_alb.alb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn 
}