resource "datadog_dashboard_json" "app-1" {
  dashboard = templatefile("${path.module}/dashboard.json.tmpl", {
    elasticbeanstalk_env = "eb-app"
  })
}

resource "datadog_dashboard_json" "app-2" {
  dashboard = templatefile("${path.module}/dashboard.json.tmpl", {
    elasticbeanstalk_env = "aleidy"
  })
}


//#RDS
//resource "datadog_dashboard" "RDS" {
//
//  title       = "RDS Dashboard"
//  layout_type = "ordered"
//
//  dynamic "widget" {
//    for_each = var.metrics_rds
//    content {
//      timeseries_definition {
//        request {
//          q            = "avg:${widget.value}{dbinstanceidentifier:*} by {dbinstanceidentifier}"
//          display_type = "line"
//        }
//        title = widget.value
//        yaxis {
//          scale = "linear"
//        }
//      }
//    }
//  }
//}
//
//#Elasticache
//resource "datadog_dashboard" "Elasticache" {
//
//  title       = "Elasticache Dashboard"
//  layout_type = "ordered"
//
//  dynamic "widget" {
//    for_each = var.metrics_elasticache
//    content {
//      timeseries_definition {
//        request {
//          q            = "avg:${widget.value}{placeholder:*} by {placeholder}" #TODO
//          display_type = "line"
//        }
//        title = widget.value
//        yaxis {
//          scale = "linear"
//        }
//      }
//    }
//  }
//}
//
//#Lambda
//resource "datadog_dashboard" "Lambda" {
//
//  title       = "Lambda Dashboard"
//  layout_type = "ordered"
//
//  dynamic "widget" {
//    for_each = var.metrics_lambda
//    content {
//      timeseries_definition {
//        request {
//          q            = "avg:${widget.value}{functionname:*} by {functionname}"
//          display_type = "line"
//        }
//        title = widget.value
//        yaxis {
//          scale = "linear"
//        }
//      }
//    }
//  }
//}
//
//#LoadBalancer
//resource "datadog_dashboard" "loadbalancer" {
//
//  title       = "LoadBalancer Dashboard"
//  layout_type = "ordered"
//
//  dynamic "widget" {
//    for_each = var.metrics_loadbalancer
//    content {
//      timeseries_definition {
//        request {
//          q            = "avg:${widget.value}{loadbalancer:*} by {loadbalancer}"
//          display_type = "line"
//        }
//        title = widget.value
//        yaxis {
//          scale = "linear"
//        }
//      }
//    }
//  }
//}

