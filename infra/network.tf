# variables
variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "name_prefix" {
  type        = string
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}
variable "main_network_block" {
  type        = string
  description = "Base CIDR block to be used in our VPC."
}
variable "public_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks to be used in public subnets"
}
variable "private_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks to be used in private subnets"
}
variable "cluster_azs" {
  type        = list(string)
  description = "List of Availability Zones to be used in EKS"
}

# get all available AZs in a region
data "aws_availability_zones" "available_azs" {
  state = "available"
  filter {
    name   = "zone-name"
    values = var.cluster_azs
  }
}

# reserve Elastic IP to be used for NAT gateway
resource "aws_eip" "nat_gw_elastic_ip" {
  vpc = true

  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

# create VPC using the public AWS module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "${var.name_prefix}-vpc"
  cidr = var.main_network_block
  azs  = data.aws_availability_zones.available_azs.names

  private_subnets = var.private_cidr_blocks
  public_subnets  = var.public_cidr_blocks

  # enable single NAT Gateway to save some money
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true
  reuse_nat_ips          = true
  external_nat_ip_ids    = [aws_eip.nat_gw_elastic_ip.id]

  # VPC/Subnet tags required by EKS
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# create security group to be used later by the ingress ALB
resource "aws_security_group" "alb" {
  name   = "${var.name_prefix}-alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.name_prefix}-alb"
  }
}
