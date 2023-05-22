variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to be created in our EKS Cluster."
}
variable "iac_environment_tag" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
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
variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create."
}
variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
}
variable "ingress_gateway_name" {
  type        = string
  description = "Load-balancer service name."
}
variable "ingress_gateway_iam_role" {
  type        = string
  description = "IAM Role Name associated with load-balancer service."
}
variable "ingress_gateway_chart_name" {
  type        = string
  description = "Ingress Gateway Helm chart name."
}
variable "ingress_gateway_chart_repo" {
  type        = string
  description = "Ingress Gateway Helm repository name."
}
variable "ingress_gateway_chart_version" {
  type        = string
  description = "Ingress Gateway Helm chart version."
}
variable "geo_app_chart_name" {
  type = string
  description = "Geo app Helm chart name"
}
variable "geo_app_chart_path" {
  type = string
  description = "Geo app Helm chart path"
}
variable "geo_app_chart_namespace" {
  type = string
  description = "Kubernetes namespace to deploy geo app Helm chart"
}
/*
variable "subnet_prefix_extension" {
  type        = number
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}
variable "zone_offset" {
  type        = number
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}
variable "spot_termination_handler_chart_name" {
  type        = string
  description = "EKS Spot termination handler Helm chart name."
}
variable "spot_termination_handler_chart_repo" {
  type        = string
  description = "EKS Spot termination handler Helm repository name."
}
variable "spot_termination_handler_chart_version" {
  type        = string
  description = "EKS Spot termination handler Helm chart version."
}
variable "spot_termination_handler_chart_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy EKS Spot termination handler Helm chart."
}
variable "dns_base_domain" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
}
variable "external_dns_iam_role" {
  type        = string
  description = "IAM Role Name associated with external-dns service."
}
variable "external_dns_chart_name" {
  type        = string
  description = "Chart Name associated with external-dns service."
}
variable "external_dns_chart_repo" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}
variable "external_dns_chart_version" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}
variable "external_dns_values" {
  type        = map(string)
  description = "Values map required by external-dns service."
}
variable "admin_users" {
  type        = list(string)
  description = "List of Kubernetes admins."
}
variable "developer_users" {
  type        = list(string)
  description = "List of Kubernetes developers."
}
*/