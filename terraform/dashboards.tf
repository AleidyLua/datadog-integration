#RDS
resource "datadog_dashboard" "RDS" {

  title       = "RDS Dashboard"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics_rds
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{dbinstanceidentifier:*} by {dbinstanceidentifier}"
          display_type = "line"
        }
        title = widget.value
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

#Elasticache
resource "datadog_dashboard" "Elasticache" {

  title       = "Elasticache Dashboard"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics_elasticache
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{placeholder:*} by {placeholder}" #TODO
          display_type = "line"
        }
        title = widget.value
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

#Lambda
resource "datadog_dashboard" "Lambda" {

  title       = "Lambda Dashboard"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics_lambda
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{functionname:*} by {functionname}"
          display_type = "line"
        }
        title = widget.value
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

#LoadBalancer
resource "datadog_dashboard" "loadbalancer" {

  title       = "LoadBalancer Dashboard"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = var.metrics_loadbalancer
    content {
      timeseries_definition {
        request {
          q            = "avg:${widget.value}{loadbalancer:*} by {loadbalancer}"
          display_type = "line"
        }
        title = widget.value
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

#ElasticBeanStalk
resource "datadog_dashboard" "app_red_dashboard" {
  for_each = var.application_elasticbean

  title       = "${each.value} Dashboard (RED)"
  layout_type = "ordered"

  # Panel 1: Total Request Count
  widget {
    timeseries_definition {
      request {
        q            = "sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name}"
        display_type = "bars"
      }
      title        = "Request Count"
      show_legend  = true
      yaxis {
        scale = "linear"
      }
    }
  }

  # Panel 2: Error Rate Percentage vs Success Percentage
  widget {
    timeseries_definition {
      request {
        q            = "100 * sum:application_error_count{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} / sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name}, 100 * (sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} - sum:application_error_count{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name}) / sum:aws.elasticbeanstalk.application_requests_total{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name}"
        display_type = "line"
      }
      title        = "Error Rate vs Success Percentage"
      show_legend  = true
      yaxis {
        scale        = "linear"
        include_zero = true
        min          = 0
        max          = 100
      }
    }
  }

  # Panel 3: Request Latency (p90, p95, p99)
  widget {
    timeseries_definition {
      request {
        q            = "avg:aws.elasticbeanstalk.application_latency_p_9_0{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name},avg:aws.elasticbeanstalk.application_latency_p_9_5{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name},avg:aws.elasticbeanstalk.application_latency_p_9_9_9{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name}"
        display_type = "line"
      }
      title        = "Request Latency (p90, p95, p99)"
      show_legend  = true
      yaxis {
        scale = "linear"
      }
    }
  }
}