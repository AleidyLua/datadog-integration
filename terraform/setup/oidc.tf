module "github_oidc_role" {
  source                         = "../modules/github_oidc"
  organization                   = var.organization
  beanstalk_artifact_bucket_name = "beanstalk-artifacts-945702879066"
}