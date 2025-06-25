# Cria o cognito user pool
resource "aws_cognito_user_pool" "this" {
  name = "cgnt-${var.env}-${var.project}-auth"

  # Verifica e-mail automaticamente
  auto_verified_attributes = ["email"]
}

# Cria o cognito user pool client
resource "aws_cognito_user_pool_client" "this" {
  name = "cgnt-${var.env}-${var.project}-client"
  user_pool_id = aws_cognito_user_pool.this.id

  # Configurações de autenticação (permitir USER_PASSWORD_AUTH para teste via AWS CLI)
  generate_secret = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  # Apenas Cognito como provedor
  supported_identity_providers = ["COGNITO"]
}