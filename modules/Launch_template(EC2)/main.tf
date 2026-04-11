resource "aws_launch_template" "template" {
  name = "Template"
  image_id = var.ami
  instance_type = var.instance_type
  key_name = "key1"
  user_data = base64encode(file("${path.module}/userdata.sh"))
  vpc_security_group_ids = [var.tmp_sg]
}