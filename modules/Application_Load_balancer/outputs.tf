output "target_id" {
  value = aws_lb_target_group.target_group.id
}

output "lb_id" {
  value = aws_alb.alb.id
}

output "alb_dns" {
  value = aws_alb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.target_group.arn 
}