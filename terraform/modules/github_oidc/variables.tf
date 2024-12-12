variable "organization" {
  description = "The GitHub organization in the format 'owner/repo' for the OIDC condition."
  type        = string
}

variable "beanstalk_artifact_bucket_name" {
  type = string
  description = "The S3 bucket where beanstalk artifacts are being uploaded"
}