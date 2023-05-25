terraform {
  required_version = "1.4.6"

  cloud {
    organization = "iurkenty"
    workspaces {
      name = "sandbox"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

data "aws_caller_identity" "current" {} # used for accessing Account ID and ARN


provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Dev        = "Iurii"
      Project    = "eks"
      Zaibal     = "True"
    }
  }
} 