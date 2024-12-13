resource "datadog_dashboard_json" "dashboard_json" {
  for_each = var.beanstalk_environment_names
  dashboard = templatefile("${path.module}/beanstalk_dashboard.json.tmpl", {
    elasticbeanstalk_env = each.value
  })
}