resource "datadog_dashboard_json" "dashboard_json" {
  for_each = var.beanstalk_environment_names
  dashboard = templatefile("beanstalk_dashboard.json.tmpl", {
    beanstalk_environment_name = each.value
  })
}

variable "beanstalk_environment_names" {
  type = list(string)
}