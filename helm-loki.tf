
resource "time_sleep" "wait_for_kubernetes" {

    depends_on = [
        data.aws_eks_cluster.tg-tekton-eks-cluster
    ]

    create_duration = "20s"
}

resource "null_resource" "example" {
  provisioner "local-exec" {
   command    = "cat ~/.kube/config"
  }
}

resource "helm_release" "loki" {
 
  name       = "${var.release_name}"  
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "${var.namespace}"
  create_namespace = false
  version    = "2.8.7"
  timeout = 2000
  set {
    name  = "fluent-bit.enabled"
    value = false
  }
  set {
    name  = "promtail.enabled"
    value = true
  }
  set {
    name  = "server.persistentVolume.enabled"
    value = true
  }
  set {
    name  = "grafana.datasources.enabled"
    value = true
  }
  set {
    name  = "server.persistence.enabled"
    value = true
  }
    
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
  
