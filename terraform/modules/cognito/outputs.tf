# Saídas para expor informações úteis
output "user_pool_id" {
  description   = "ID do Cognito User Pool"
  value         = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description   = "ARN do Cognito User Pool"
  value         = aws_cognito_user_pool.this.arn
}

output "user_pool_client_id" {
  description   = "ID do Cognito User Pool Client"
  value         = aws_cognito_user_pool_client.this.id
}