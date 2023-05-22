# variables
variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create"
}
variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}

# EKS cluster
module "cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.1"

  cluster_name                    = var.cluster_name
  cluster_version                 = "1.26"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  subnet_ids                      = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  eks_managed_node_groups         = var.eks_managed_node_groups

  node_security_group_additional_rules = {
    # allow connections from ALB security group
    ingress_allow_access_from_alb_sg = {
      type                     = "ingress"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      source_security_group_id = aws_security_group.alb.id
    }
    # allow connections from EKS to the internet
    egress_all = {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # allow connections from EKS to EKS (internal calls)
    ingress_self_all = {
      protocol  = "-1"
      from_port = 0
      to_port   = 0
      type      = "ingress"
      self      = true
    }
  }
}
output "node_sg" {
  value = module.cluster.node_security_group_id
}
output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}
output "cluster_certificate_authority_data" {
  value = module.cluster.cluster_certificate_authority_data
}

# IAM role for AWS Load Balancer Controller
module "eks_ingress_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.1"

  role_name                              = "load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Autoscaling policy
resource "aws_autoscaling_policy" "eks_autoscaling_policy" {
  count = length(var.eks_managed_node_groups)

  name                   = "${module.cluster.eks_managed_node_groups_autoscaling_group_names[count.index]}-autoscaling-policy"
  autoscaling_group_name = module.cluster.eks_managed_node_groups_autoscaling_group_names[count.index]
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.autoscaling_average_cpu
  }
}
