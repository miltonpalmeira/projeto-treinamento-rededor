variable "api_name" {
  type        = string
  description = "Nome da API Gateway"
}

variable "stage_name" {
  type        = string
  description = "Nome do estágio (ex: dev)"
}
variable "lambda_auth_arn" {
  type        = string
  description = "ARN da Lambda de autenticação (/login)"
}
variable "lambda_backend_arn" {
  type        = string
  description = "ARN da Lambda de backend (/private)"
}
variable "user_pool_arn" {
  type        = string
  description = "ARN do Cognito User Pool (para autorização)"
}