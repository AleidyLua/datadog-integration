output "oidc_role_arn" {
  description = "The ARN of the IAM role from the module."
  value       = module.github_oidc_role.role_arn
}