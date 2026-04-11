variable "vpc_cidr_block" {
  type = string
}


variable "public_subnet1_cidr" {
    type = string
  
}


variable "public_subnet2_cidr" {
  type = string
}

variable "asg_subnet_cidr" {
  type = string
}

variable "private_subnet2_cidr" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

# variable "asg_subnets_id" {
#   type = string
# }