# variables
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

# deploy Ingress Controller
resource "kubernetes_service_account" "load_balancer_controller" {
  metadata {
    name      = var.ingress_gateway_name
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = var.ingress_gateway_name
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ingress_gateway_iam_role}"
    }
  }
}
resource "kubernetes_secret" "load_balancer_controller" {
  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true

  metadata {
    namespace     = kubernetes_service_account.load_balancer_controller.metadata.0.namespace
    generate_name = "${kubernetes_service_account.load_balancer_controller.metadata.0.name}-token"
    annotations   = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.load_balancer_controller.metadata.0.name
    }
  }
}
resource "helm_release" "ingress_gateway" {
  name       = var.ingress_gateway_chart_name
  chart      = var.ingress_gateway_chart_name
  repository = var.ingress_gateway_chart_repo
  version    = var.ingress_gateway_chart_version
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.load_balancer_controller.metadata.0.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}
