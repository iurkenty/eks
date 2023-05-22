# create EKS cluster
module "infra" {
  source = "./infra/"

  cluster_name            = var.cluster_name
  name_prefix             = var.name_prefix
  main_network_block      = var.main_network_block
  cluster_azs             = var.cluster_azs
  eks_managed_node_groups = var.eks_managed_node_groups
  autoscaling_average_cpu = var.autoscaling_average_cpu
  private_cidr_blocks     = var.public_cidr_blocks
  public_cidr_blocks      = var.private_cidr_blocks
}

# provision EKS cluster
module "k8s" {
  source = "./k8s/"

  cluster_name                             = var.cluster_name
  cluster_endpoint                         = module.infra.cluster_endpoint
  cluster_certificate_authority_data       = module.infra.cluster_certificate_authority_data
  namespaces                               = var.namespaces
  ingress_gateway_name                     = var.ingress_gateway_name
  ingress_gateway_iam_role                 = var.ingress_gateway_iam_role
  ingress_gateway_chart_name               = var.ingress_gateway_chart_name
  ingress_gateway_chart_repo               = var.ingress_gateway_chart_repo
  ingress_gateway_chart_version            = var.ingress_gateway_chart_version
  geo_app_chart_name                       = var.geo_app_chart_name
  geo_app_chart_path                       = var.geo_app_chart_path
  geo_app_chart_namespace                  = var.geo_app_chart_namespace
}
