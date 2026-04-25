# -----------------------------
# WAF
# -----------------------------
resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.study_name}-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Managed rule: commonRuleSetを使う

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.study_name}-waf-rule-metric"
      sampled_requests_enabled   = true
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.study_name}-waf-metric"
    sampled_requests_enabled   = true
  }

  tags = merge(local.common_tags, {
    Name = "${var.study_name}-waf"
  })
}


# -----------------------------
# WAFのALBへの関連付け
# -----------------------------
resource "aws_wafv2_web_acl_association" "waf_ass" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}


# -----------------------------
# CloudWatch設定
# -----------------------------
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