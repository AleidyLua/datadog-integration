# Beanstalk Dashboards and Monitors
This Terraform stack provisions beanstalk dashboards and monitors/alerts in DataDog.

## How to deploy
This stack uses workspaces to deploy: `staging` and `prod`.

To deploy:
1. Verify the `beanstalk_environment_names` in the `staging.tfvars` and/or `prod.tfvars` files first.
2. Run `terraform init`.
3. Run `terraform workspace select staging` (or `terraform workspace select prod`).
4. Run `terraform plan --var-file staging.tfvars` (or `terraform plan --var-file prod.tfvars`).
5. Confirm the plan output looks good.
6. Run `terraform apply --var-file staging.tfvars` (or `terraform plan --var-file prod.tfvars`).
7. Manually enter `yes` and wait for the apply to finish.

**Make sure you are on the correct workspace BEFORE running apply.**
