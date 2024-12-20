module "beanstalk_app_dashboards" {
  source                      = "../modules/datadog_beanstalk"
  beanstalk_environment_names = var.beanstalk_environment_names
}