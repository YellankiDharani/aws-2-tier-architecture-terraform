# AWS 2-Tier Architecture using Terraform (ALB + ASG)

## Overview

This project demonstrates a production-ready 2-tier architecture on AWS using Terraform.
It implements a scalable and highly available web application infrastructure using Application Load Balancer (ALB) and Auto Scaling Group (ASG).

---

## Architecture

The architecture consists of the following components:

* Public Layer

  * Application Load Balancer (ALB)
  * Public Subnets across multiple Availability Zones

* Application Layer

  * EC2 Instances (Apache Web Server)
  * Auto Scaling Group (ASG)
  * Private Subnets

* Networking

  * Custom VPC
  * Internet Gateway
  * NAT Gateway for outbound internet access

---

## Architecture Flow

```text
Internet
   ↓
Application Load Balancer (ALB)
   ↓
Auto Scaling Group (EC2 Instances)
   ↓
Private Subnets
```

---

## Technologies Used

* AWS (VPC, EC2, ALB, ASG, NAT Gateway)
* Terraform (Infrastructure as Code)

---

## Project Structure

```text
two-tier-aws-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
│
└── modules/
    ├── vpc/
    ├── subnets/
    ├── nat/
    ├── security_groups/
    ├── alb/
    ├── launch_template/
    └── autoscaling/
```

---

## Security

* ALB allows HTTP (port 80) from the internet
* EC2 instances allow traffic only from the ALB
* Instances are deployed in private subnets

---

## Deployment Steps

1. Initialize Terraform

```
terraform init
```

2. Plan Infrastructure

```
terraform plan
```

3. Apply Configuration

```
terraform apply
```

---

## Output

When accessing the ALB DNS, the application dynamically displays:

Instance ID
Private IP Address
Client IP Address
Sample Output:

🚀 2-Tier Project Working
Instance ID: i-xxxxxxxxxxxx
Private IP: 10.x.x.x
Client IP: xxx.xxx.xxx.xxx

---

## Key Features

* Highly available architecture across multiple Availability Zones
* Auto Scaling for handling varying workloads
* Secure network design using public and private subnets
* Fully automated infrastructure using Terraform

---

## Use Case

This project is suitable for:

* Learning AWS architecture
* Practicing DevOps concepts
* Showcasing hands-on experience in cloud projects

---


