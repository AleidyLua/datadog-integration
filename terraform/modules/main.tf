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

resource "datadog_dashboard" "app_dashboard" {

  title       = "${var.application} Dashboard"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{elasticbeanstalk_environment-name:${var.environment}}"
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
  query    = "avg(last_1h):avg:${each.value}{elasticbeanstalk_environment-name:${var.environment}} > 80"
  monitor_thresholds {
    critical = 80
  }
  message  = <<EOT
Custom metric: Application errors exceeded threshold in Elastic Beanstalk environments

Notify: @aleidy@iliosllc.com
See more details in Datadog: https://app.datadoghq.com/monitors
EOT
  escalation_message = "check alert"

  tags = ["env: ${var.environment}"]

  notify_no_data   = false

  renotify_interval = 60  # Renotify after 60 minutes if the issue persists

  timeout_h    = 0  # No timeout for alerts
}
