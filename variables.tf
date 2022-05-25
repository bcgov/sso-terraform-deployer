variable "name" {
  description = "Service account name"
  default     = "project-deployer"
}

variable "namespace" {
  description = "Openshift Project to create k8s objects in"
}

variable "ops_bcgov" {
  description = "Whether to manage bcgov API group resources"
  type        = bool
  default     = false
}
