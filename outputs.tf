output "default_secret_name" {
  description = "Service account secret name"
  value       = kubernetes_service_account.this.default_secret_name
}
