variable "cluster_name" {
  description = "cluster name"
  type        = string
}
variable "release_name" {
  description = "Helm release name"
  type        = string
}
variable "namespace" {
  description = "Installing namespace"
  type        = string
}
variable "region" {
  description = "Installing region"
  type        = string
}

