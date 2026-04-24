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

