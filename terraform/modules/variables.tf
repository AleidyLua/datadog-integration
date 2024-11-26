variable "application" {
  type        = string
}

variable "environment" {
  description = "Environment names by app"
  type = string
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



