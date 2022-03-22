# ---
# create a security group for lambda deployed inside a vpc
# 
resource "aws_security_group" "lambda_vpc_sg" {
  name                        = "${var.app_shortcode}_lambda_sg"
  vpc_id                      = data.aws_vpc.given.id

  ingress {
    cidr_blocks               = var.source_cidr_blocks
    from_port                 = 443
    to_port                   = 443
    protocol                  = "tcp"
  }

  egress {
    cidr_blocks               = data.aws_vpc.given.cidr_block_associations.*.cidr_block
    from_port                 = 443
    to_port                   = 443
    protocol                  = "tcp"
  }

  tags                        = local.common_tags
}

# ---
# create Lambda execution IAM role, giving permissions to access other AWS services
#
resource "aws_iam_role" "lambda_exec_role" {
  name                = "${var.app_shortcode}_Lambda_Exec_Role"
  assume_role_policy  = jsonencode({
    Version         = "2012-10-17"
    Statement       = [
      {
        Action      = [ "sts:AssumeRole" ]
        Principal   = {
            "Service": "lambda.amazonaws.com"
        }
        Effect      = "Allow"
        Sid         = "LambdaAssumeRolePolicy"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.app_shortcode}_Lambda_Policy"
  path        = "/"
  description = "IAM policy with minimum permissions for ${var.lambda_name} Lambda function"

  policy = jsonencode({
    Version         = "2012-10-17"
    Statement       = [
      {
        Action      = [
          "logs:CreateLogGroup",
        ]
        Resource    = "arn:aws:logs:${var.aws_region}:${local.account_id}:*"
        Effect      = "Allow"
        Sid         = "AllowCloudWatchLogsAccess"
      }, 
      {
        Action      = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource    = "arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"
        Effect      = "Allow"
        Sid         = "AllowCloudWatchPutLogEvents"
      }, 
      {
        Action      = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Resource    = "arn:aws:s3:::*"
        Effect      = "Allow"
        Sid         = "AllowS3ReadWriteAccessForTfStatefile"
      }, 
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# ---
# create cloudwatch log group for lambda
#
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}

# ---
# Upload and create Lambda function
#

data "archive_file" "lambda_archive" {
  source_dir                = "${path.module}/src/lambda"
  output_file_mode          = "0755"
  output_path               = "${path.module}/dist/${var.lambda_name}_package.zip"
  type                      = "zip"

  #depends_on = [ null_resource.lambda_build ]
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = var.lambda_name 

  handler          = "function.handler"
  role             = aws_iam_role.lambda_exec_role.arn
  runtime          = "provided.al2"
  #timeout          = 60

  filename         = data.archive_file.lambda_archive.output_path
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256

  #environment {
  #  variables = {
  #  }
  #}

  tags             = local.common_tags
}

