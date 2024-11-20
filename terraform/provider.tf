terraform {
 required_providers {
   datadog = {
     source = "DataDog/datadog"
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


