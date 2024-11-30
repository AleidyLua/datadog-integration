# Terraform Datadog AWS Integration

This project configures AWS and Datadog integration using Terraform. It creates the necessary AWS IAM roles and policies, along with Datadog dashboards and monitors for various AWS services like RDS, Elasticache, Lambda, Elastic Beanstalk, and Application Load Balancer.

## Features

- **AWS Datadog Integration**: Sets up IAM roles and policies for Datadog to access AWS metrics.
- **Dashboards**: Creates Datadog dashboards for:
  - RDS
  - Elasticache
  - Lambda
  - Elastic Beanstalk
  - Application Load Balancer
- **Alerts**: Configures metric-based alerts in Datadog for these AWS services.

## Requirements

- Terraform `>= 1.0.0`
- AWS provider `~> 5.0`
- Datadog provider `~> 3.48.0`

## Prerequisites

1. **AWS Credentials**: Ensure AWS credentials are configured via `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, or through a credentials file.
2. **Datadog API and App Keys**:
   - Store these keys in AWS Systems Manager Parameter Store:
     - `/datadog/api_key`
     - `/datadog/app_key`

## Variables

### AWS
| Variable | Description                  |
|----------|------------------------------|
| `region` | AWS region to deploy in      |
| `application_elasticbean`|  List of Elastic Beanstalk application names          |


### Metrics
| Variable                 | Description                                   |
|--------------------------|-----------------------------------------------|
| `metrics_rds`            | List of RDS metrics to monitor               |
| `metrics_elasticache`    | List of Elasticache metrics to monitor       |
| `metrics_lambda`         | List of Lambda metrics to monitor            |
| `metrics_elasticbean`    | List of Elastic Beanstalk metrics to monitor |
| `metrics_loadbalancer`   | List of Application Load Balancer metrics    |

### Adding New Metrics
To monitor additional metrics, update the respective variable in the `variables.tf` file.

## Resources Created

### AWS
- **IAM Role**: `DatadogAWSIntegrationRole`
- **IAM Policies**:
  - Custom policy with permissions to access AWS services.
  - AWS-managed `SecurityAudit` policy.

### Datadog
- **Integration**: Configures AWS integration with Datadog.
- **Dashboards**: Custom dashboards for RDS, Elasticache, Lambda, Elastic Beanstalk, and Application Load Balancer.
- **Monitors**: Metric-based alerts for each service.

