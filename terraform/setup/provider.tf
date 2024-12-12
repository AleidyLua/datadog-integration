#####################################
### Provider and State information
#####################################
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.48.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-infrastructure-945702879066"
    key    = "setup/terraform.tfstate"
    region = "us-east-2"
  }
}
data "aws_caller_identity" "current" {}


provider "datadog" {
  api_key = jsondecode(data.aws_secretsmanager_secret_version.datadog_keys.secret_string)["api_key"]
  app_key = jsondecode(data.aws_secretsmanager_secret_version.datadog_keys.secret_string)["app_key"]
  api_url = "https://api.datadoghq.com"
}

data "aws_secretsmanager_secret" "datadog_keys" {
  name = "datadog_keys"
}

data "aws_secretsmanager_secret_version" "datadog_keys" {
  secret_id = data.aws_secretsmanager_secret.datadog_keys.id
}

provider "aws" {
  region = "us-east-2"
}