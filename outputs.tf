output "metadata" {
  description = "Block status of the deployed release."
  value       = try(helm_release.this[0].metadata, null)
}
