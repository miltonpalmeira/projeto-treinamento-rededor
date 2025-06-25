data "aws_region" "current" {}
output "api_endpoint" {
  description = "URL de invocação da API (sem path final)"
  value       = "https://${aws_api_gateway_rest_api.this.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${var.stage_name}"
}