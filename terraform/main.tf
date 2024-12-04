locals {
  dashboard_metrics = {
    for app_name in var.application_elasticbean : app_name => [
      for metric in var.metrics_elasticbean : {
        query = replace(metric.query, "your-environment-name", app_name)
        title = metric.title
      }
    ]
  }
}
# data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::464622532012:root"] #TODO hard coded account number? is this datadog?
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "sts:ExternalId"
#
#       values = [
#         datadog_integration_aws.datadog.external_id
#       ]
#     }
#   }
# }
#
# data "aws_iam_policy_document" "datadog_aws_integration" {
#   statement {
#     actions = [
#       "apigateway:GET",
#       "autoscaling:Describe*",
#       "backup:List*",
#       "backup:ListRecoveryPointsByBackupVault",
#       "bcm-data-exports:GetExport",
#       "bcm-data-exports:ListExports",
#       "budgets:ViewBudget",
#       "cassandra:Select",
#       "cloudfront:GetDistributionConfig",
#       "cloudfront:ListDistributions",
#       "cloudtrail:DescribeTrails",
#       "cloudtrail:GetTrailStatus",
#       "cloudtrail:LookupEvents",
#       "cloudwatch:Describe*",
#       "cloudwatch:Get*",
#       "cloudwatch:List*",
#       "codedeploy:BatchGet*",
#       "codedeploy:List*",
#       "cur:DescribeReportDefinitions",
#       "directconnect:Describe*",
#       "dynamodb:Describe*",
#       "dynamodb:List*",
#       "ec2:Describe*",
#       "ec2:GetSnapshotBlockPublicAccessState",
#       "ec2:GetTransitGatewayPrefixListReferences",
#       "ec2:SearchTransitGatewayRoutes",
#       "ecs:Describe*",
#       "ecs:List*",
#       "elasticache:Describe*",
#       "elasticache:List*",
#       "elasticfilesystem:DescribeAccessPoints",
#       "elasticfilesystem:DescribeFileSystems",
#       "elasticfilesystem:DescribeTags",
#       "elasticloadbalancing:Describe*",
#       "elasticmapreduce:Describe*",
#       "elasticmapreduce:List*",
#       "es:DescribeElasticsearchDomains",
#       "es:ListDomainNames",
#       "es:ListTags",
#       "events:CreateEventBus",
#       "fsx:DescribeFileSystems",
#       "fsx:ListTagsForResource",
#       "glacier:GetVaultNotifications",
#       "glue:ListRegistries",
#       "health:DescribeAffectedEntities",
#       "health:DescribeEventDetails",
#       "health:DescribeEvents",
#       "kinesis:Describe*",
#       "kinesis:List*",
#       "lambda:GetPolicy",
#       "lambda:List*",
#       "lightsail:GetInstancePortStates",
#       "logs:DeleteSubscriptionFilter",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#       "logs:DescribeSubscriptionFilters",
#       "logs:FilterLogEvents",
#       "logs:PutSubscriptionFilter",
#       "logs:TestMetricFilter",
#       "oam:ListAttachedLinks",
#       "oam:ListSinks",
#       "organizations:Describe*",
#       "organizations:List*",
#       "rds:Describe*",
#       "rds:List*",
#       "redshift:DescribeClusters",
#       "redshift:DescribeLoggingStatus",
#       "route53:List*",
#       "s3:GetBucketLocation",
#       "s3:GetBucketLogging",
#       "s3:GetBucketNotification",
#       "s3:GetBucketTagging",
#       "s3:ListAccessGrants",
#       "s3:ListAllMyBuckets",
#       "s3:PutBucketNotification",
#       "savingsplans:DescribeSavingsPlanRates",
#       "savingsplans:DescribeSavingsPlans",
#       "ses:Get*",
#       "sns:GetSubscriptionAttributes",
#       "sns:List*",
#       "sns:Publish",
#       "sqs:ListQueues",
#       "states:DescribeStateMachine",
#       "states:ListStateMachines",
#       "support:DescribeTrustedAdvisor*",
#       "support:RefreshTrustedAdvisorCheck",
#       "tag:GetResources",
#       "tag:GetTagKeys",
#       "tag:GetTagValues",
#       "timestream:DescribeEndpoints",
#       "waf-regional:ListRuleGroups",
#       "waf-regional:ListRules",
#       "waf:ListRuleGroups",
#       "waf:ListRules",
#       "wafv2:GetIPSet",
#       "wafv2:GetLoggingConfiguration",
#       "wafv2:GetRegexPatternSet",
#       "wafv2:GetRuleGroup",
#       "wafv2:ListLoggingConfigurations",
#       "xray:BatchGetTraces",
#       "xray:GetTraceSummaries"
#     ]
#     resources = ["*"]
#   }
# }
#
# resource "aws_iam_policy" "datadog_aws_integration" {
#   name   = "DatadogAWSIntegrationPolicy-${terraform.workspace}"
#   policy = data.aws_iam_policy_document.datadog_aws_integration.json
# }
#
# resource "aws_iam_role" "datadog_aws_integration" {
#   name               = "DatadogAWSIntegrationRole-${terraform.workspace}"
#   description        = "Role for Datadog AWS Integration"
#   assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
# }
#
# resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
#   role       = aws_iam_role.datadog_aws_integration.name
#   policy_arn = aws_iam_policy.datadog_aws_integration.arn
# }
#
# resource "aws_iam_role_policy_attachment" "datadog_aws_integration_security_audit" {
#   role       = aws_iam_role.datadog_aws_integration.name
#   policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
# }

data "aws_caller_identity" "current" {}

# resource "datadog_integration_aws" "datadog" {
#   account_id = data.aws_caller_identity.current.account_id
#   role_name  = "DatadogAWSIntegrationRole-${terraform.workspace}"
# }


#Dashboards and alerts

#RDS
# resource "datadog_dashboard" "RDS" {
#
#   title       = "RDS Dashboard-${terraform.workspace}"
#   layout_type = "ordered"
#
#   dynamic "widget" {
#     for_each = var.metrics_rds
#     content {
#       timeseries_definition {
#         request {
#           q            = "avg:${widget.value}{dbinstanceidentifier:*} by {dbinstanceidentifier}" #TODO What is the todo?
#           display_type = "line"
#         }
#         title = widget.value
#         yaxis {
#           scale = "linear"
#         }
#       }
#     }
#   }
# }

# resource "datadog_monitor" "RDS" {
#   for_each = var.metrics_rds
#
#   name  = "RDS Alert for ${each.value}"
#   type  = "metric alert"
#   query = "avg(last_1h):avg:${each.value}{dbinstanceidentifier:*} by {dbinstanceidentifier} > 80" #TODO ?
#
#   monitor_thresholds {
#     critical = 80
#   }
#
#   //TODO make it notify a variable or even list of emails. Also implement anywhere else there are alerts
#   message = <<EOT
# Alert triggered for: {{dbinstanceidentifier.id}}.
# Notify: @aleidy@iliosllc.com
# See more details in Datadog: https://app.datadoghq.com/monitors
# EOT
#
#   escalation_message = "Please investigate this alert."
#
#   tags = [
#     "RDS"
#   ]
#
#   notify_no_data    = false
#   renotify_interval = 60  # Renotify after 60 minutes if the issue persists
#   timeout_h         = 0   # No timeout for alerts
# }


#Elasticache
# resource "datadog_dashboard" "Elasticache" {
#
#   title       = "Elasticache Dashboard"
#   layout_type = "ordered"
#
#   dynamic "widget" {
#     for_each = var.metrics_elasticache
#     content {
#       timeseries_definition {
#         request {
#           q            = "avg:${widget.value}{placeholder:*} by {placeholder}" #TODO
#           display_type = "line"
#         }
#         title = widget.value
#         yaxis {
#           scale = "linear"
#         }
#       }
#     }
#   }
# }

# resource "datadog_monitor" "Elasticache" {
#   for_each = var.metrics_elasticache
#
#   name  = "Elasticache Alert for ${each.value}"
#   type  = "metric alert"
#   query = "avg(last_1h):avg:${each.value}{placeholder:*} by {placeholder} > 80" #TODO
#
#   monitor_thresholds {
#     critical = 80
#   }
#
#   message = <<EOT
# Alert triggered for: {{placeholder.name}}.
# Notify: @aleidy@iliosllc.com
# See more details in Datadog: https://app.datadoghq.com/monitors
# EOT
#
#   // TODO do we have any other information that can be used to make this more meaningful?
#   escalation_message = "Please investigate this alert."
#
#   tags = [
#     "Elasticache"
#   ]
#
#   notify_no_data    = false
#   renotify_interval = 60  # Renotify after 60 minutes if the issue persists
#   timeout_h         = 0   # No timeout for alerts
# }


#LAMBDA
# resource "datadog_dashboard" "Lambda" {
#
#   title       = "Lambda Dashboard"
#   layout_type = "ordered"
#
#   dynamic "widget" {
#     for_each = var.metrics_lambda
#     content {
#       timeseries_definition {
#         request {
#           q            = "avg:${widget.value}{functionname:*} by {functionname}"
#           display_type = "line"
#         }
#         title = widget.value
#         yaxis {
#           scale = "linear"
#         }
#       }
#     }
#   }
# }

# resource "datadog_monitor" "Lambda" {
#   for_each = var.metrics_lambda
#
#   name  = "Lambda Alert for ${each.value}"
#   type  = "metric alert"
#   query = "avg(last_1h):avg:${each.value}{functionname:*} by {functionname} > 80" #TODO
#
#   monitor_thresholds {
#     critical = 80
#   }
#
#   message = <<EOT
# Alert triggered for function: {{functionname.name}}.
# Notify: @aleidy@iliosllc.com
# See more details in Datadog: https://app.datadoghq.com/monitors
# EOT
#
#   escalation_message = "Please investigate this alert."
#
#   tags = [
#     "Lambda"
#   ]
#
#   notify_no_data    = false
#   renotify_interval = 60  # Renotify after 60 minutes if the issue persists
#   timeout_h         = 0   # No timeout for alerts
# }

#ElasticBeanStalk
resource "datadog_dashboard" "app_dashboard" {
  #Creates a dashboard per application
  for_each = local.dashboard_metrics

  title       = "${each.key} - Dashboard (${terraform.workspace})"
  layout_type = "ordered"

  dynamic "widget" {
    for_each = each.value

    content {
      timeseries_definition {
        request {
          q            = widget.value.query
          display_type = "line"
        }
        title = widget.value.title
        yaxis {
          scale = "linear"
        }
      }
    }
  }
}

# resource "datadog_monitor" "app_alerts" {
#   for_each = var.metrics_elasticbean
#
#   name  = "App ElasticBean Alert for ${each.value}"
#   type  = "metric alert"
#   query = "avg(last_1h):avg:${each.value}{elasticbeanstalk_environment-name:*} by {elasticbeanstalk_environment-name} > 80"
#   monitor_thresholds {
#     critical = 80
#   }
#   message            = <<EOT
# Alert triggered for: {{elasticbeanstalk_environment-name.name}}.
#
# Notify: @aleidy@iliosllc.com
# See more details in Datadog: https://app.datadoghq.com/monitors
# EOT
#   escalation_message = "check alert"
#
#   tags = ["ElasticBeanStalk"]
#
#   notify_no_data = false
#
#   renotify_interval = 60  # Renotify after 60 minutes if the issue persists
#
#   timeout_h = 0  # No timeout for alerts
# }

#LoadBalancer
# resource "datadog_dashboard" "loadbalancer" {
#
#   title       = "LoadBalancer Dashboard"
#   layout_type = "ordered"
#
#   dynamic "widget" {
#     for_each = var.metrics_loadbalancer
#     content {
#       timeseries_definition {
#         request {
#           q            = "avg:${widget.value}{loadbalancer:*} by {loadbalancer}"
#           display_type = "line"
#         }
#         title = widget.value
#         yaxis {
#           scale = "linear"
#         }
#       }
#     }
#   }
# }
#
# resource "datadog_monitor" "loadbalancer" {
#   for_each = var.metrics_loadbalancer
#
#   name  = "Loadbalancer Alert for ${each.value}"
#   type  = "metric alert"
#   query = "avg(last_1h):avg:${each.value}{loadbalancer:*} by {loadbalancer} > 80"
#
#   monitor_thresholds {
#     critical = 80
#   }
#
#   message = <<EOT
# Alert triggered for: {{loadbalancer.name}}.
# Notify: @aleidy@iliosllc.com
# See more details in Datadog: https://app.datadoghq.com/monitors
# EOT
#
#   escalation_message = "Please investigate this alert."
#
#   tags = [
#     "loadbalancer"
#   ]
#
#   notify_no_data    = false
#   renotify_interval = 60  # Renotify after 60 minutes if the issue persists
#   timeout_h         = 0   # No timeout for alerts
# }
#



