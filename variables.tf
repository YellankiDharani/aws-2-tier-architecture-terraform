variable "region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
  
}

# variable "web_subnet_cidr_block" {
#   type = string
# }

# variable "web_subnet_availablity_zone" {
#   type = string
# }

# variable "private_cidr_block" {
#   type = string
# }

# variable "private_availablity_zone" {
#   type = string
# }

variable "private_cidr_blocks" {
  type = list(string)
  
}

variable "private_availability_zones" {
  type = list(string)
}

variable "web_subnets_cidr_blocks" {
  type = list(string)
  
}

variable "web_subnets_availablity_Zones" {
  type = list(string)
  
}

variable "RDS_subnet_cidr_block" {
  type = string
  
}

variable "RDS_subnet_availablity_zone" {
  type = string
}

# variable "RDS_subnet_2_cidr_block" {
#   type = string
  
# }

# variable "RDS_subnets_cidr_blocks" {
#   type = list(string)
  
# }

# variable "RDS_subnet_availablity_zone" {
#   type = list(string)
  
# }

variable "cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "image_id" {
  type = string
  
}

variable "instance_type" {
  type = string
}