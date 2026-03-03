resource "aws_wafv2_web_acl_association" "waf_ass" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
