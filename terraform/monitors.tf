# Define metric queries for all resources
locals {
  # Elastic Beanstalk Metrics
  elasticbean_metric_queries = {
    request_count   = "avg(last_1h):avg:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 60000"
    error_rate      = "avg(last_1h):100 * sum:aws.elasticbeanstalk.application_errors{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} / sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 5"
    latency_p99     = "avg(last_1h):avg:aws.elasticbeanstalk.application_latency_p_9_9{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 500"
    cpu_utilization = "avg(last_1h):avg:aws.ec2.cpuutilization{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 80"
    network_out     = "avg(last_1h):avg:aws.ec2.network_out{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 600000"
  }

  # RDS Metrics
  rds_metric_queries = {
    cpu_utilization      = "avg(last_1h):avg:aws.rds.cpuutilization{dbinstanceidentifier:*} by {dbinstanceidentifier} > 80"
    free_storage_space   = "avg(last_1h):avg:aws.rds.free_storage_space{dbinstanceidentifier:*} by {dbinstanceidentifier} < 10000000000"
    database_connections = "avg(last_1h):avg:aws.rds.database_connections{dbinstanceidentifier:*} by {dbinstanceidentifier} > 200"
  }

  # Elasticache Metrics
  elasticache_metric_queries = {
    cpu_utilization    = "avg(last_1h):avg:aws.elasticache.cpuutilization{cacheclusterid:*} by {cacheclusterid} > 80"
    swap_usage         = "avg(last_1h):avg:aws.elasticache.swapusage{cacheclusterid:*} by {cacheclusterid} > 50"
    evictions          = "avg(last_1h):avg:aws.elasticache.evictions{cacheclusterid:*} by {cacheclusterid} > 100"
  }

  # Lambda Metrics
  lambda_metric_queries = {
    invocation_count   = "avg(last_1h):avg:aws.lambda.invocations{functionname:*} by {functionname} > 1000"
    error_count        = "avg(last_1h):avg:aws.lambda.errors{functionname:*} by {functionname} > 10"
    duration_p99       = "avg(last_1h):avg:aws.lambda.duration.p99{functionname:*} by {functionname} > 3000"
  }

  # LoadBalancer Metrics
  loadbalancer_metric_queries = {
    healthy_host_count = "avg(last_1h):avg:aws.elb.healthy_host_count{loadbalancer:*} by {loadbalancer} < 2"
    request_count      = "avg(last_1h):avg:aws.elb.request_count{loadbalancer:*} by {loadbalancer} > 50000"
    latency_p99        = "avg(last_1h):avg:aws.elb.latency.p99{loadbalancer:*} by {loadbalancer} > 5"
  }
}

# Elastic Beanstalk Monitors
resource "datadog_monitor" "app_alerts" {
  for_each = local.elasticbean_metric_queries

  name  = "App ElasticBean Alert for ${each.key}"
  type  = "metric alert"
  query = each.value

  message = <<EOT
Alert triggered for: {{elasticbeanstalk_environment-name.name}}.
Metric: ${each.key}.
Notify: ${join(", ", var.notification_emails)}
Details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Elastic Beanstalk Alert for {{elasticbeanstalk_environment-name.name}}: ${each.key}. Investigate at: https://app.datadoghq.com/monitors"
  tags = ["ElasticBeanstalk", each.key]

  renotify_interval = 60
  timeout_h         = 0
}

# RDS Monitors
resource "datadog_monitor" "rds" {
  for_each = local.rds_metric_queries

  name  = "RDS Alert for ${each.key}"
  type  = "metric alert"
  query = each.value

  message = <<EOT
Alert triggered for: {{dbinstanceidentifier.id}}.
Metric: ${each.key}.
Notify: ${join(", ", var.notification_emails)}
Details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "RDS Alert for {{dbinstanceidentifier.id}}: ${each.key}. Investigate at: https://app.datadoghq.com/monitors"
  tags = ["RDS", each.key]

  renotify_interval = 60
  timeout_h         = 0
}

# Elasticache Monitors
resource "datadog_monitor" "elasticache" {
  for_each = local.elasticache_metric_queries

  name  = "Elasticache Alert for ${each.key}"
  type  = "metric alert"
  query = each.value

  message = <<EOT
Alert triggered for: {{cacheclusterid.name}}.
Metric: ${each.key}.
Notify: ${join(", ", var.notification_emails)}
Details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Elasticache Alert for {{cacheclusterid.name}}: ${each.key}. Investigate at: https://app.datadoghq.com/monitors"
  tags = ["Elasticache", each.key]

  renotify_interval = 60
  timeout_h         = 0
}

# Lambda Monitors
resource "datadog_monitor" "lambda" {
  for_each = local.lambda_metric_queries

  name  = "Lambda Alert for ${each.key}"
  type  = "metric alert"
  query = each.value

  message = <<EOT
Alert triggered for: {{functionname.name}}.
Metric: ${each.key}.
Notify: ${join(", ", var.notification_emails)}
Details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Lambda Alert for {{functionname.name}}: ${each.key}. Investigate at: https://app.datadoghq.com/monitors"
  tags = ["Lambda", each.key]

  renotify_interval = 60
  timeout_h         = 0
}

# LoadBalancer Monitors
resource "datadog_monitor" "loadbalancer" {
  for_each = local.loadbalancer_metric_queries

  name  = "LoadBalancer Alert for ${each.key}"
  type  = "metric alert"
  query = each.value

  message = <<EOT
Alert triggered for: {{loadbalancer.name}}.
Metric: ${each.key}.
Notify: ${join(", ", var.notification_emails)}
Details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "LoadBalancer Alert for {{loadbalancer.name}}: ${each.key}. Investigate at: https://app.datadoghq.com/monitors"
  tags = ["LoadBalancer", each.key]

  renotify_interval = 60
  timeout_h         = 0
}
