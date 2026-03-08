resource "aws_cloudwatch_log_group" "waf_log" {
  name              = "aws-waf-logs-${var.study_name}"
  retention_in_days = 14

  tags = merge(local.common_tags, {
    Name = "${var.study_name}-waf-logs"
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_config" {
  resource_arn = aws_wafv2_web_acl.waf.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf_log.arn
  ]
}
