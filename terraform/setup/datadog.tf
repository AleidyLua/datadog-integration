module "datadog_integration" {
  source         = "../modules/datadog_integration"
  aws_account_id = data.aws_caller_identity.current.account_id
}