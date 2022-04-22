variable "name" {
  description = "Service account name"
  default     = "project-deployer"
}

variable "namespace" {
  description = "Openshift Project to create k8s objects in"
}
