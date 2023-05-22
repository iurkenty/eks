# variables
variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for your Kubernetes API server."
}
variable "cluster_certificate_authority_data" {
  type        = string
  description = "Base64 encoded certificate data required to communicate with the cluster."
}

# EKS authentication to be able to manage k8s objects from terraform
provider "kubernetes" {
  host                    = var.cluster_endpoint
  cluster_ca_certificate  = base64decode(var.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}
# Helm provider block to be able to deploy helm charts
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}