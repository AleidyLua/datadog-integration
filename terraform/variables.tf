variable "region" {
  type    = string
  default = "us-east-2"
}

variable "metrics_rds" {
  description = "List of metrics for RDS"
  type        = set(string)
  default = [
    "aws.rds.cpuutilization",
    "aws.rds.freeable_memory",
    "aws.rds.free_storage_space",
    "aws.rds.read_latency",
    "aws.rds.write_latency",
    "aws.rds.database_connections"
  ]
}

variable "metrics_elasticache" {
  description = "List of metrics for RDS"
  type        = set(string)
  default = [
    "aws.elasticache.cpuutilization",
    "aws.elasticache.freeable_memory",
    "aws.elasticache.swapusage",
    "aws.elasticache.network_bytes_in",
    "aws.elasticache.network_bytes_out",
    "aws.elasticache.curr_connections",
    "aws.elasticache.evictions",
    "aws.elasticache.cache_hits",
    "aws.elasticache.cache_misses",
    "aws.elasticache.replication_lag",
    "aws.elasticache.bytes_used_for_cache"
  ]
}

variable "metrics_lambda" {
  description = "List of metrics for RDS"
  type        = set(string)
  default = [
    "aws.lambda.errors",
    "aws.lambda.throttles",
    "aws.lambda.duration",
    "aws.lambda.concurrent_executions",
    "aws.lambda.unreserved_concurrent_executions",
    "aws.lambda.destination_delivery_failures"
  ]
}

variable "application_elasticbean" {
  type    = set(string)
  default = ["eb-app"]
}

variable "metrics_elasticbean" {
  description = "List of metrics for Elastic Beanstalk"
  type        = set(string)
  default = [
    "aws.ec2.cpuutilization",
    "aws.ec2.network_in",
    "aws.ec2.network_out",
    "third_party_api_call_duration",
    "application_error_count"
  ]
}

variable "metrics_loadbalancer" {
  description = "List of metrics for metrics loadbalancer"
  type        = set(string)
  default = [
    "aws.applicationelb.target_response_time.maximum",
    "aws.applicationelb.http_5xx_count",
    "aws.applicationelb.target_connection_error_count",
    "aws.applicationelb.target_response_time",
    "aws.applicationelb.target_health_failed_count"
  ]
}

variable "notification_emails" {
  description = "List of email addresses to notify in case of an alert."
  type        = list(string)
  default     = ["@aleidy@iliosllc.com"]
}
