variable "applications" {
  description = "List of applications"
  type        = set(string)
  default     = ["ebs-app"]
}

variable "environment" {
  description = "Map of environment names by app"
  type = map(list(string))
  default = {
    ebs-app = ["ebs-app"]
  }
}

variable "metrics" {
  description = "List of metrics for Elastic Beanstalk"
  type        = set(string)
  default     = [
    "aws.ec2.cpuutilization",
    "aws.ec2.memoryutilization",
    "aws.ec2.networkin",
    "aws.ec2.networkout",
    "aws.applicationelb.target_response_time.maximum",
    "third_party_api_call_duration",
    "application_error_count"
  ]
}



