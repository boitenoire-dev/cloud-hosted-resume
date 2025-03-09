resource "aws_cloudwatch_log_group" "visitorlogs" {
  name = "visitorlogs_${aws_api_gateway_rest_api.visitorapi.id}/production"
  tags = {
    Environment = "Production"
    Application = "Cloud Resume Project"
  }
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.visitorlogs.arn
}
