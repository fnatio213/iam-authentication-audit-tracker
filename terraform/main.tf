provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "cloudtrail_kms" {
  description             = "KMS key for encrypting CloudTrail logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "iam-auth-tracker-logs"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.cloudtrail_kms.arn
      }
    }
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "log-archive-bucket"
    target_prefix = "cloudtrail/"
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_logs_block" {
  bucket                  = aws_s3_bucket.cloudtrail_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudtrail" "iam_audit_trail" {
  name                          = "iam-auth-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.cloudtrail_kms.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.iam_audit_logs.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_logs_role.arn
}

resource "aws_cloudwatch_log_group" "iam_audit_logs" {
  name              = "/aws/cloudtrail/iam-audit-log"
  kms_key_id        = aws_kms_key.cloudtrail_kms.arn
  retention_in_days = 90
}

resource "aws_iam_role" "cloudtrail_logs_role" {
  name = "CloudTrail_Logs_To_CW"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  name = "AllowCWLogsWrite"
  role = aws_iam_role.cloudtrail_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = aws_cloudwatch_log_group.iam_audit_logs.arn
      }
    ]
  })
}

resource "aws_cloudwatch_log_metric_filter" "failed_console_logins" {
  name           = "FailedConsoleLogins"
  log_group_name = aws_cloudwatch_log_group.iam_audit_logs.name
  pattern        = "{ $.eventName = \"ConsoleLogin\" && $.responseElements.ConsoleLogin = \"Failure\" }"

  metric_transformation {
    name      = "FailedConsoleLogins"
    namespace = "IAMAnomalies"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "failed_login_alarm" {
  alarm_name          = "FailedLoginsAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.failed_console_logins.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.failed_console_logins.metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}

resource "aws_sns_topic" "security_alerts" {
  name              = "SecurityAlerts"
  kms_master_key_id = aws_kms_key.cloudtrail_kms.arn
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

# GitHub Actions Trigger Note:
# This version of main.tf has been hardened to meet tfsec recommendations and compliance best practices.
