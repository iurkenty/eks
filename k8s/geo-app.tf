# Variables
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

resource "helm_release" "geo_app" {
  name          = var.geo_app_chart_name
  chart         = var.geo_app_chart_path
  namespace     = var.geo_app_chart_namespace
  wait_for_jobs = true
}