# Networking
cluster_name            = "geo-app-eks"
iac_environment_tag     = "development"
name_prefix             = "geo-app"
main_network_block      = "10.0.0.0/16"
public_cidr_blocks      = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
private_cidr_blocks     = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
cluster_azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]

# EKS Cluster
autoscaling_average_cpu = 30
eks_managed_node_groups = {
   default_node_group = {
    attach_cluster_primary_security_group = true
    use_custom_launch_template            = false
    disk_size = 50
  }
/*
  "geo-app-eks-x86" = {
    ami_type     = "AL2_x86_64"
    min_size     = 1
    max_size     = 10
    desired_size = 1
    instance_types = [
      "t3.medium"
    ]
    capacity_type = "ON_DEMAND"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size             = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            delete_on_termination = true
        }
      }
    }
  }
*/
}