# 2- tier project 

#Creating VPC

resource "aws_vpc" "project_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    tags = {
      Name = "PROJECT-VPC"
    
    }
}

#Creating Two Public subnets for the Web Layer

# resource "aws_subnet" "web_subnet" {
#     vpc_id = aws_vpc.project-vpc.id
#     cidr_block = var.web_subnet_cidr_block
#     availability_zone = var.web_subnet_availablity_zone
#     map_public_ip_on_launch = true
#     tags = {
#       Name = "web-subnet"
#     }
# }

# resource "aws_subnet" "private_subnet" {
#     vpc_id = aws_vpc.project-vpc.id
#     cidr_block = var.private_cidr_block
#     availability_zone = var.private_availablity_zone
#     map_public_ip_on_launch = false
#      tags = {
#        Name= "private-subnet"
#      }
# }

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = var.private_availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "web_Layer_subnets" {
    count = length(var.web_subnets_cidr_blocks)
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = var.web_subnets_cidr_blocks[count.index] 
     #var.web_subnets_cidr_blocks[0]->10.0.1.0/24 , var.web_subnets_cidr_blocks[1]->10.0.2.0/24 , 
    availability_zone = var.web_subnets_availablity_Zones[count.index]
    #var.web_subnets_availabity_Zones[0] -> us-east-1a , var.web_subnets_availabity_Zones[1] -> us-east-1b
    map_public_ip_on_launch = true

    tags = {
      Name = "web-subnet-${count.index+1}" #web-subnet-1,web-subnet-2
    }
}


#creating private subnet for the Database Layer

resource "aws_subnet" "RDS_subnet" {
    vpc_id = aws_vpc.project_vpc.id
    cidr_block = var.RDS_subnet_cidr_block
    availability_zone = var.RDS_subnet_availablity_zone
    map_public_ip_on_launch = false
     tags = {
       Name= "RDS-subnet"
     }
}

# resource "aws_subnet" "RDS_subnet_2" {
#     vpc_id = aws_vpc.project-vpc.id
#     cidr_block = var.web_subnet_2_cidr_block
#     availability_zone = "us-east-1a"
#     map_public_ip_on_launch = false
#      tags = {
#        Name= "RDS-subnet-2"
#      }
# }

# resource "aws_subnet" "RDS_subents" {
#     count = length(var.RDS_subnets_cidr_blocks)
#     vpc_id = aws_vpc.project-vpc.id
#     cidr_block = var.RDS_subnets_cidr_blocks[count.index]
#     availability_zone = var.RDS_subents_availablity_zones[count.index]
#     map_public_ip_on_launch = false
#     tags = {
#       Name = "RDS-subnet-${count.index+1}"
#     }
  
# }

#Creating Internet gateway

resource "aws_internet_gateway" "Project_IGW" {
    vpc_id = aws_vpc.project_vpc.id
    tags = {
      Name = "Project-IGW"
    }
  
}


#creating ElasticIP for NATGATEWAY allocation

resource "aws_eip" "ElasticIP" {
    domain = "vpc"

    tags = {
      Name = "NAT-EIP"
    }
    
}

#ATTACHING NAT GATEWAY TO THE PUBLIC SUBNET 

resource "aws_nat_gateway" "nat_gateway" {
    subnet_id = aws_subnet.web_Layer_subnets[0].id
    # subnet_id = aws_subnet.web_subnet.id
    allocation_id = aws_eip.ElasticIP.id

    tags = {
      Name = "nat-gateway"
    }
}

#Creating Route table 

resource "aws_route_table" "web_route_table" {
    vpc_id = aws_vpc.project_vpc.id

    route {
        gateway_id = aws_internet_gateway.Project_IGW.id
        cidr_block = "0.0.0.0/0"
    } 

    tags = {
        Name = "web-route-table"
    } 

}

#Associating web_subnet_1 and web_subnet_2 to the web-route-table

resource "aws_route_table_association" "web_subnets_association" {
    count = length(aws_subnet.web_Layer_subnets)
    subnet_id = aws_subnet.web_Layer_subnets[count.index].id
    route_table_id = aws_route_table.web_route_table.id
  
}

resource "aws_route_table" "rds_route_table" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "rds-route-table"
  }
}

resource "aws_route_table_association" "rds_association" {
  subnet_id      = aws_subnet.RDS_subnet.id
  route_table_id = aws_route_table.rds_route_table.id
}

# resource "aws_route_table_association" "web_subnet_association" {
#   subnet_id = aws_subnet.web_subnet.id
#   route_table_id = aws_route_table.web_route_table.id
# }

#CREATING ROUTE TABLE FOR PRIVATE SUBNETS
 
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.project_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }
    tags = {
      Name = "private-Route-table"
    }
  
}

resource "aws_route_table_association" "private_subents_association" {
    count = length(aws_subnet.private_subnets)
    subnet_id = aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private_route_table.id
}

# resource "aws_route_table_association" "private_subnet_association" {
#   subnet_id = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private_route_table.id
  
# }

#SECURITY GROUP FOR THE ASG

resource "aws_security_group" "security_group" {
      name = "security-group"
      vpc_id = aws_vpc.project_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ALB_security_group.id]
  }
  
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#SECURITY GROUP FOR THE ALB

resource "aws_security_group" "ALB_security_group" {
      name = "ALB-security-group"
      vpc_id = aws_vpc.project_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#CREATING APPLICATION LOAD BALANCER FOR APPLICATION

resource "aws_lb" "load_balancer" {
    load_balancer_type = "application"
    name = "load-balancer"
    subnets = aws_subnet.web_Layer_subnets[*].id
    security_groups = [aws_security_group.ALB_security_group.id]
    # subnets = [aws_subnet.web_subnet.id]
}

#CREATING TARGET GROUP FOR THE LOAD BALANCER LISTENER 

resource "aws_lb_target_group" "Target_Group" {
    port = 80
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = aws_vpc.project_vpc.id
    
    health_check {
      path = "/"
      healthy_threshold = 5
      unhealthy_threshold = 2
      timeout = 5
      interval = 30

    }

    tags = {
      Name = "Target-group"
    }

}

#LISTENER

resource "aws_lb_listener" "listener" {
    port = 80
    protocol = "HTTP"
    load_balancer_arn = aws_lb.load_balancer.arn
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.Target_Group.arn
    }
}

#TEMPLATE FOR THE AUTO SCALING GROUP

resource "aws_launch_template" "Template" {
  name = "Template"
  image_id = var.image_id
  instance_type = var.instance_type
  key_name = "key-pair"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  user_data = base64encode(file("${path.module}/user-data.sh"))
}

#AUTO SCALING GROUP

resource "aws_autoscaling_group" "Auto_scaling_group" {
  name = "auto-scaling-group"
  desired_capacity = 5
  min_size = 1
  max_size = 5
  # vpc_zone_identifier = aws_subnet.private_subnets[*].id
  # vpc_zone_identifier = [aws_subnet.private_subnet.id]
  vpc_zone_identifier = aws_subnet.web_Layer_subnets[*].id
  target_group_arns = [aws_lb_target_group.Target_Group.arn]
  launch_template {
  id = aws_launch_template.Template.id
  version = "$Latest"
  }
}

