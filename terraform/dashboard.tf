//resource "datadog_dashboard" "default_metrics_dashboard" {
//  title       = "Default Metrics Dashboard"
//  layout_type = "ordered"
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:aws.ec2.cpuutilization{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "CPU Utilization"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:aws.ec2.memoryutilization{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Memory Utilization"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:aws.ec2.networkin{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Network In"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:aws.ec2.networkout{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Network Out"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:aws.applicationelb.target_response_time.maximum{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Page Load Time"
//    }
//  }
//}
//
//resource "datadog_dashboard" "custom_metrics_dashboard" {
//  title       = "Custom Metrics Dashboard"
//  layout_type = "ordered"
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:third_party_api_call_duration{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Custom Metric: Example"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:custom.application_error_count{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Custom Metric: Application Errors"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//
//  widget {
//    timeseries_definition {
//      request {
//        q            = "avg:custom.queue_length{elasticbeanstalk_environment-name:${var.beanstalk_environment}}"
//        display_type = "line"
//      }
//      title = "Custom Metric: Queue Length"
//      yaxis {
//        scale = "linear"
//      }
//    }
//  }
//}
//
//resource "datadog_monitor" "high_cpu_alert" {
//  name     = "High CPU Utilization Alert"
//  type     = "metric alert"
//  query    = "avg(last_5m):avg:aws.ec2.cpuutilization{elasticbeanstalk_environment-name:${var.beanstalk_environment}} > 80"
//  message  = <<EOT
//High CPU utilization detected in Elastic Beanstalk environment: ${var.beanstalk_environment}.
//
//Notify: @aleidy@iliosllc.com
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Escalation: High CPU utilization exceeded 80%. Immediate action required."
//
//  tags = ["env:${var.beanstalk_environment}"]
//
//  notify_no_data   = true
//  no_data_timeframe = 10
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  notify_audit = true
//  timeout_h    = 0  # No timeout for alerts
//}
//
//
//resource "datadog_monitor" "high_memory_alert" {
//  name     = "High Memory Utilization Alert"
//  type     = "metric alert"
//  query    = "avg(last_5m):avg:aws.ec2.memoryutilization{elasticbeanstalk_environment-name:${var.beanstalk_environment}} > 85"
//  message  = <<EOT
//High memory utilization detected in Elastic Beanstalk environment: ${var.beanstalk_environment}.
//
//Notify: @aleidy@iliosllc.com
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Escalation: High memory utilization exceeded 85%. Immediate action required."
//
//  tags = ["env:${var.beanstalk_environment}"]
//
//  notify_no_data   = true
//  no_data_timeframe = 10
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  notify_audit = true
//  timeout_h    = 0  # No timeout for alerts
//}
//
//resource "datadog_monitor" "ec2_status_check_alert" {
//  name     = "EC2 Status Check Failure"
//  type     = "metric alert"
//  query    = "avg(last_5m):avg:aws.ec2.statuscheckfailed{elasticbeanstalk_environment-name:${var.beanstalk_environment}} > 0"
//  message  = <<EOT
//EC2 status check failure detected in Elastic Beanstalk environment: ${var.beanstalk_environment}.
//
//Notify: @aleidy@iliosllc.com
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Escalation: EC2 instance status check failed."
//
//  tags = ["env:${var.beanstalk_environment}"]
//
//  notify_no_data   = true
//  no_data_timeframe = 10
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  notify_audit = true
//  timeout_h    = 0  # No timeout for alerts
//}
//
//resource "datadog_monitor" "custom_api_call_alert" {
//  name     = "High API Call Duration Alert"
//  type     = "metric alert"
//  query    = "avg(last_5m):avg:third_party_api_call_duration{elasticbeanstalk_environment-name:${var.beanstalk_environment}} > 50"
//  message  = <<EOT
//Custom metric: API call duration exceeded threshold in Elastic Beanstalk environment: ${var.beanstalk_environment}.
//
//Notify: @aleidy@iliosllc.com
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Escalation: API call duration exceeded 50ms."
//
//  tags = ["env:${var.beanstalk_environment}"]
//
//  notify_no_data   = true
//  no_data_timeframe = 10
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  notify_audit = true
//  timeout_h    = 0  # No timeout for alerts
//}
//
//resource "datadog_monitor" "custom_app_error_alert" {
//  name     = "High Application Error Alert"
//  type     = "metric alert"
//  query    = "avg(last_5m):avg:custom.application_error_count{elasticbeanstalk_environment-name:${var.beanstalk_environment}} > 100"
//  message  = <<EOT
//Custom metric: Application errors exceeded threshold in Elastic Beanstalk environment: ${var.beanstalk_environment}.
//
//Notify: @aleidy@iliosllc.com
//See more details in Datadog: https://app.datadoghq.com/monitors
//EOT
//  escalation_message = "Escalation: Application error count exceeded 100."
//
//  tags = ["env:${var.beanstalk_environment}"]
//
//  notify_no_data   = true
//  no_data_timeframe = 10
//
//  renotify_interval = 60  # Renotify after 60 minutes if the issue persists
//
//  notify_audit = true
//  timeout_h    = 0  # No timeout for alerts
//}
//
//
//
//
