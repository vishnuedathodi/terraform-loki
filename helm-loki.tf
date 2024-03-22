
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
  chart      = "grafana/loki-stack"
  namespace  = "prometheus"
  create_namespace = false
  version    = "2.7.0"
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
    value = false
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
  
