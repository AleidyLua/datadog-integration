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
  default = ["ebs-app"]
}

variable "metrics_elasticbean" {
  description = "List of metrics for Elastic Beanstalk"
  # <<<<<<< HEAD
  type = list(object(
    {
      query = string
      title = string
    }
  ))
  default = [
    {
      query            = "aws.ec2.cpuutilization{elasticbeanstalk_environment-name:your-environment-name}, aws.ec2.cpuutilization.maximum{elasticbeanstalk_environment-name:your-environment-name}"
      title            = "Cpu Utilization"
      yAxisMin         = null
      yAxisMax         = null
      yAxisIncludeZero = false
    },
    {
      query            = "system{elasticbeanstalk_environment-name:your-environment-name}, max:aws.ec2.memoryutilization{elasticbeanstalk_environment-name:your-environment-name}"
      title            = "Memory Utilization"
      yAxisMin         = null
      yAxisMax         = null
      yAxisIncludeZero = false
    },
    {
      query            = "sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:your-environment-name}"
      title            = "Request Count"
      yAxisMin         = null
      yAxisMax         = null
      yAxisIncludeZero = false
    },
    {
      query            = "100 * sum:application_error_count{elasticbeanstalk_environment-name:your-environment-name} / sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:your-environment-name}, 100 * (sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:your-environment-name} - sum:application_error_count{elasticbeanstalk_environment-name:your-environment-name}) / sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:your-environment-name}"
      title            = "Error vs Success Percentage"
      yAxisMin         = 0
      yAxisMax         = 100
      yAxisIncludeZero = true
    },
    {
      query            = "avg:aws.elasticbeanstalk.application_latency_p_9_0{elasticbeanstalk_environment-name:your-environment-name},avg:aws.elasticbeanstalk.application_latency_p_9_5{elasticbeanstalk_environment-name:your-environment-name},avg:aws.elasticbeanstalk.application_latency_p_9_9_9{elasticbeanstalk_environment-name:your-environment-name}"
      title            = "Request Latency (p90, p95, p99)"
      yAxisMin         = null
      yAxisMax         = null
      yAxisIncludeZero = false
    },
    #      {
    #       query = "avg:aws.ec2.cpuutilization{elasticbeanstalk_environment-name:your-environment-name}, max:aws.ec2.cpuutilization{elasticbeanstalk_environment-name:your-environment-name}"
    #       title = "Cpu Utilization"
    #     }
    # =======
    #   type        = set(string)
    #   default = [
    #     "aws.ec2.cpuutilization",
    #     "aws.ec2.network_in",
    #     "aws.ec2.network_out",
    #     "third_party_api_call_duration",
    #     "application_error_count"
    # >>>>>>> 90a793a06f540ee170db016abe926eb094e82223
  ]
  #   default     = [
  #     "aws.ec2.cpuutilization",
  #     "aws.ec2.memoryutilization",
  #     "aws.ec2.networkin",
  #     "aws.ec2.networkout",
  #     "third_party_api_call_duration",
  #     "application_error_count"
  #   ]
  # }
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

variable "elasticbean_env" {
  default = "eb-app"
}