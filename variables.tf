variable "name" {
  description = "Service account name"
  default     = "project-deployer"
}

variable "namespace" {
  description = "Openshift Project to create the service account in"
}

variable "privileged_namespaces" {
  description = "Openshift Projects to assign privileges to the service account"
  type        = list(string)
}

variable "ops_bcgov" {
  description = "Whether to manage bcgov API group resources"
  type        = bool
  default     = false
}

variable "bcgov_tsc" {
  description = "Whether to manage bcgov Transport Server Claims"
  type        = bool
  default     = false
}
