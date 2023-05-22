# Ingress
ingress_gateway_name          = "aws-load-balancer-controller"
ingress_gateway_iam_role      = "load-balancer-controller"
ingress_gateway_chart_name    = "aws-load-balancer-controller"
ingress_gateway_chart_repo    = "https://aws.github.io/eks-charts"
ingress_gateway_chart_version = "1.4.1"

# List of namespaces
namespaces = ["geo-app"]

# Geo-App
geo_app_chart_name      = "geo-app"
geo_app_chart_path      = "./geo-app"
geo_app_chart_namespace = "geo-app"