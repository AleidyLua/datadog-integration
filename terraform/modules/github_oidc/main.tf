# # Create an OIDC provider for GitHub Actions
# resource "aws_iam_openid_connect_provider" "this" {
#   url = "https://token.actions.githubusercontent.com"
#
#   client_id_list = [
#     "sts.amazonaws.com",
#   ]
#
#   # The thumbprints are only used as a fallback for OIDC verification when AWS' other method fails, but they are released by GitHub and don't change frequently.
#   # AWS Docs: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
#   # GitHub Announcement: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
# }

data "aws_iam_openid_connect_provider" "this" {
  url = "https://token.actions.githubusercontent.com"
}

# Create a trust policy document for the role
data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringLike"
      values   = [var.organization]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

# Create the IAM role
resource "aws_iam_role" "this" {
  name               = "Beanstalk-GitHub-OIDC-role"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach-deploy" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy_document" "beanstalk_update_and_deploy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.beanstalk_artifact_bucket_name}",  # S3 bucket
      "arn:aws:s3:::${var.beanstalk_artifact_bucket_name}/*" # All objects within the bucket
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticbeanstalk:CreateApplicationVersion",
      "elasticbeanstalk:DescribeApplicationVersions",
      "elasticbeanstalk:UpdateEnvironment",
      "elasticbeanstalk:DescribeEnvironments",
      "elasticbeanstalk:DescribeEnvironmentResources"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "beanstalk_upload_and_deploy" {
  policy = data.aws_iam_policy_document.beanstalk_update_and_deploy.json
}

resource "aws_iam_role_policy_attachment" "attach_beanstalk_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.beanstalk_upload_and_deploy.arn
}
