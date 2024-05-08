terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
        version = ">= 2.0.0"
        source = "hashicorp/kubernetes"
    }

    # kubectl = {
    #   #source = "gavinbunney/kubectl"
    #   #version = ">= 1.7.0"
    #   source  = "alekc/kubectl"
    #   version = ">= 2.0.0"
    # }
  }
}


data "aws_eks_cluster" "installationcluster" {
  name = "${var.cluster_name}"
}
data "aws_eks_cluster_auth" "installationcluster" {
  name = "${var.cluster_name}"
}


provider "aws" {
  region     = "${var.region}"
}

provider "helm" {
    kubernetes {
       host                   = data.aws_eks_cluster.installationcluster.endpoint
       cluster_ca_certificate = base64decode(data.aws_eks_cluster.installationcluster.certificate_authority[0].data)
       token                  = data.aws_eks_cluster_auth.installationcluster.token
       config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
    }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.installationcluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.installationcluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.installationcluster.token
 #  version          = "2.16.1"
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }

}

# provider "kubectl" {
#    load_config_file = false
#    host                   = data.aws_eks_cluster.installationcluster.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.installationcluster.certificate_authority[0].data)
#    token                  = data.aws_eks_cluster_auth.installationcluster_auth.token
#    exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws-iam-authenticator"
#     args = [
#       "token",
#       "-i",
#       module.eks.cluster_id,
#     ]
#       }
#     config_path = "~/.kube/config"

# }


#export the kubeconfig file

#export KUBECONFIG=~/.kube/config
