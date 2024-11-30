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


