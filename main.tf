module "VPC" {
  source = "./modules/VPC"
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet1 = module.subnets.public_subnet1_id
  public_subnet2 = module.subnets.public_subnet2_id  
  asg_subnet = module.subnets.asg_subnet_id 
  subnet_id = module.subnets.public_subnet1_id               
}

module "subnets" {
  source = "./modules/Subnets"
  vpc_id = module.VPC.vpc_id
  public_subnet1_cidr = var.public_subnet1_cidr
  public_subnet2_cidr = var.public_subnet2_cidr
  asg_subnet_cidr = var.asg_subnet_cidr
  private_subnet2_cidr = var.private_subnet2_cidr
}

module "security_groups" {
  source = "./modules/Security_groups"
  vpc_id = module.VPC.vpc_id
}

module "Load_balancer" {
  source = "./modules/Application_Load_balancer"
  subnet_ids = [module.subnets.public_subnet1_id,
                module.subnets.public_subnet2_id]
  security_group = module.security_groups.ALB_security_group
  vpc_id = module.VPC.vpc_id
}

module "launch_template" {
  source = "./modules/Launch_template(EC2)"
  ami = var.ami
  instance_type = var.instance_type
  tmp_sg = module.security_groups.private_ec2_sg_id
}

module "Auto_scaling_group" {
  source = "./modules/Auto_scaling_group"
  asg_subnet = module.subnets.asg_subnet_id
  tmp_id = module.launch_template.template_id
  target_group_arn = module.Load_balancer.target_group_arn
}