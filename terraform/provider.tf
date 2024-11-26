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
  region = "us-east-2"
}

provider "datadog" {
 api_key = "a5923db0349798a9f923e99346d6019f"
 app_key = "896ad8a510cba847d0986d4aef1ae47c610d3be8"
 api_url = "https://api.datadoghq.com"
}
