#RDS
resource "datadog_monitor" "RDS" {
  for_each = var.metrics_rds

  name  = "RDS Alert for ${each.value}"
  type  = "metric alert"
  query = "avg(last_1h):avg:${each.value}{dbinstanceidentifier:*} by {dbinstanceidentifier} > 80"

  monitor_thresholds {
    critical = 80
  }

  message = <<EOT
Alert triggered for: {{dbinstanceidentifier.id}}.
Notify: ${join(", ", var.notification_emails)}
See more details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Alert triggered for resource {{dbinstanceidentifier.id}} Metric: {{metric_name}}. Please investigate. Details in Datadog: https://app.datadoghq.com/monitors"

  tags = [
    "RDS"
  ]

  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
  timeout_h         = 0   # No timeout for alerts
}

#Elasticache
resource "datadog_monitor" "Elasticache" {
  for_each = var.metrics_elasticache

  name  = "Elasticache Alert for ${each.value}"
  type  = "metric alert"
  query = "avg(last_1h):avg:${each.value}{placeholder:*} by {placeholder} > 80" #TODO

  monitor_thresholds {
    critical = 80
  }

  message = <<EOT
Alert triggered for: {{placeholder.name}}.
Notify: ${join(", ", var.notification_emails)}
See more details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Alert triggered for resource {{placeholder.name}} Metric: {{metric_name}}. Please investigate. Details in Datadog: https://app.datadoghq.com/monitors"

  tags = [
    "Elasticache"
  ]

  notify_no_data    = false
  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
  timeout_h         = 0   # No timeout for alerts
}

#Lambda
resource "datadog_monitor" "Lambda" {
  for_each = var.metrics_lambda

  name  = "Lambda Alert for ${each.value}"
  type  = "metric alert"
  query = "avg(last_1h):avg:${each.value}{functionname:*} by {functionname} > 80"

//  monitor_thresholds {
//    critical = 80
//  }

  message = <<EOT
Alert triggered for function: {{functionname.name}}.
Notify: ${join(", ", var.notification_emails)}
See more details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Alert triggered for resource {{functionname.name}} Metric: {{metric_name}}. Please investigate. Details in Datadog: https://app.datadoghq.com/monitors"

  tags = [
    "Lambda"
  ]

  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
  timeout_h         = 0   # No timeout for alerts
}

#LoadBalancer
resource "datadog_monitor" "loadbalancer" {
  for_each = var.metrics_loadbalancer

  name  = "Loadbalancer Alert for ${each.value}"
  type  = "metric alert"
  query = "avg(last_1h):avg:${each.value}{loadbalancer:*} by {loadbalancer} > 80"

//  monitor_thresholds {
//    critical = 80
//  }

  message = <<EOT
Alert triggered for: {{loadbalancer.name}}.
Notify: ${join(", ", var.notification_emails)}
See more details in Datadog: https://app.datadoghq.com/monitors
EOT

  escalation_message = "Alert triggered for resource {{loadbalancer.name}} Metric: {{metric_name}}. Please investigate. Details in Datadog: https://app.datadoghq.com/monitors"

  tags = [
    "loadbalancer"
  ]
  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
  timeout_h         = 0   # No timeout for alerts
}

#ElasticBeanStalk
//resource "datadog_monitor" "app_alerts" {
//  for_each = var.metrics_elasticbean
//
//  name  = "App ElasticBean Alert for ${each.value}"
//  type  = "metric alert"
//  query = "avg(last_1h):avg:${each.value}{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 60000"
////  monitor_thresholds {
////    critical = 80
////  }
//  message            = <<EOT
//Alert triggered for: {{elasticbeanstalk_environment-name.name}}.
//
//Notify: ${join(", ", var.notification_emails)}
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Alert triggered for resource {{elasticbeanstalk_environment-name.name}} Metric: {{metric_name}}. Please investigate. Details in Datadog: https://app.datadoghq.com/monitors"
//
//  tags = ["ElasticBeanStalk"]
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  timeout_h = 0  # No timeout for alerts
//}