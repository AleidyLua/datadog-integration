resource "datadog_dashboard" "app_dashboard" {
  for_each = var.applications

  title       = "Dashboard for ${each.value}"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{elasticbeanstalk_environment-name:*}"
          display_type = "line"
        }
        title = replace(widget.value, "aws.ec2.", "")
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

resource "datadog_monitor" "app_alerts" {
  for_each = var.metrics

  name     = "App Alert for ${each.value}"
  type     = "metric alert"
  query    = "avg(last_5m):avg:${each.value}{elasticbeanstalk_environment-name:*} > 80"
  message  = <<EOT
Custom metric: Application errors exceeded threshold in Elastic Beanstalk environments

Notify: @aleidy@iliosllc.com
See more details in Datadog: https://app.datadoghq.com/monitors
EOT
  escalation_message = "check alert"

  tags = ["env: ${join(", ", var.applications)}"]

  notify_no_data   = false

  renotify_interval = 60  # Renotify after 60 minutes if the issue persists

  notify_audit = true
  timeout_h    = 0  # No timeout for alerts
}

