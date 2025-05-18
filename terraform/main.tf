provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "iam-auth-tracker-logs"
  force_destroy = true
}

resource "aws_cloudtrail" "iam_audit_trail" {
  name                          = "iam-auth-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.iam_audit_logs.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs_role.arn
}

resource "aws_cloudwatch_log_group" "iam_audit_logs" {
  name = "/aws/cloudtrail/iam-audit-log"
}

resource "aws_iam_role" "cloudtrail_logs_role" {
  name = "CloudTrail_Logs_To_CW"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  name = "AllowCWLogsWrite"
  role = aws_iam_role.cloudtrail_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
      Resource = "*"
    }
