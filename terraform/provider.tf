terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.48.0"
    }
  }

  //TODO add required version, at least 1.9.0
}

terraform {
  backend "s3" {
    bucket = "721481723200-datadog-integration"
    key    = "dd.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.region
}

provider "datadog" {
  api_key = data.aws_ssm_parameter.datadog_api_key.value
  app_key = data.aws_ssm_parameter.datadog_app_key.value
  api_url = "https://api.datadoghq.com"
}

data "aws_ssm_parameter" "datadog_api_key" {
  name = "/datadog/api_key"
}

data "aws_ssm_parameter" "datadog_app_key" {
  name = "/datadog/app_key"
}


