# Datadog Monitor for Elastic Beanstalk CPU
resource "datadog_monitor" "foo" {
  name    = "High CPU Usage on Elastic Beanstalk"
  type    = "query alert"
  message = <<EOT
High CPU usage detected in the Elastic Beanstalk environment `{{environment.name}}`.
Please investigate!
EOT

  query = <<QUERY
avg(last_1h):avg:aws.elasticbeanstalk.cpu{environment:${var.beanstalk_environment}} by {host} > 4
  QUERY

  notify_no_data    = false
  renotify_interval = 30
  tags              = ["elasticbeanstalk", "cpu", "alert"]
}

#Logs
resource "datadog_logs_metric" "testing_logs_metric" {
  name = "testing.logs.metric"
  compute {
    aggregation_type = "distribution"
    path             = "@duration"
  }
  filter {
    query = "service:test"
  }
  group_by {
    path     = "@status"
    tag_name = "status"
  }
  group_by {
    path     = "@version"
    tag_name = "version"
  }
}


resource "datadog_monitor" "beanstalk_environment_health" {
  name    = "Elastic Beanstalk Environment Health Alert"
  type    = "query alert"
  query   = "avg(last_5m):max:aws.elasticbeanstalk.environment.health{environment:${var.beanstalk_environment}} > 2"
  message = "Environment `${var.beanstalk_environment}` has an unhealthy status. Check deployment status and recent logs."
  tags    = ["alert", "elasticbeanstalk", "health"]
}

resource "datadog_dashboard" "beanstalk_dashboard" {
  title       = "Elastic Beanstalk Monitoring Dashboard"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{elasticbeanstalk:${var.beanstalk_environment}}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Request Latency"
      request {
        q = "avg:aws.elasticbeanstalk.application.request.latency.count{environment:${var.beanstalk_environment}}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Error Count"
      request {
        q = "sum:aws.elasticbeanstalk.application.request.error.count{environment:${var.beanstalk_environment}}"
      }
    }
  }
}








resource "datadog_dashboard" "use_dashboard" {
  title       = "USE Metrics Dashboard"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Utilization"
      request {
        q = "avg:aws.ec2.cpuutilization{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Memory Usage"
      request {
        q = "avg:aws.ec2.memory.used_percent{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Disk Space"
      request {
        q = "avg:aws.ec2.disk.free_percent{*}"
      }
    }
  }
}

resource "datadog_dashboard" "red_dashboard" {
  title       = "RED Metrics Dashboard"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "Request Count"
      request {
        q = "sum:aws.elasticbeanstalk.application.request.count{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Error Rate"
      request {
        q = "avg:aws.elasticbeanstalk.application.request.error.count{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Request Latency"
      request {
        q = "avg:aws.elasticbeanstalk.application.request.latency{*}"
      }
    }
  }
}

resource "datadog_dashboard" "rum_dashboard" {
  title       = "RUM Metrics Dashboard"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "Frontend Page Load Time"
      request {
        q = "avg:rum.browser.page_load{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "User Actions per Minute"
      request {
        q = "sum:rum.browser.user_action{*}"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Frontend Error Rate"
      request {
        q = "avg:rum.browser.error_rate{*}"
      }
    }
  }
}

//resource "datadog_dashboard" "custom_metrics_dashboard" {
//  title       = "Custom Metrics Dashboard"
//  layout_type = "ordered"
//
//  widget {
//    timeseries_definition {
//      title = "Third-party API Call Duration"
//      request {
//        q = "avg:ticketonline.api.third_party_call.duration{*}"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      title = "Third-party API Call Errors"
//      request {
//        q = "sum:ticketonline.api.third_party_call.errors{*}"
//      }
//    }
//  }
//}

#monitors

resource "datadog_monitor" "cpu_high" {
  name    = "High CPU Utilization"
  type    = "query alert"
  query   = "avg(last_5m):avg:aws.ec2.cpuutilization{*} > 80"
  message = "CPU usage is above 80%. Investigate resource usage."
}

resource "datadog_monitor" "high_latency" {
  name    = "High Request Latency"
  type    = "query alert"
  query   = "avg(last_5m):avg:aws.elasticbeanstalk.application.request.latency{*} > 300"
  message = "Request latency is above 300ms."
}

//resource "datadog_monitor" "third_party_api_errors" {
//  name    = "High Third-party API Error Rate"
//  type    = "query alert"
//  query   = "sum(last_5m):sum:ticketonline.api.third_party_call.errors{*} > 10"
//  message = "Third-party API errors exceeded threshold."
//}

