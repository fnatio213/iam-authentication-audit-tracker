provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "iam-auth-tracker-logs"
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
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
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
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "*"
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
  name = "SecurityAlerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

# GitHub Actions Trigger Note:
# This comment ensures CI/CD is triggered and the file is terraform fmt compliant.
