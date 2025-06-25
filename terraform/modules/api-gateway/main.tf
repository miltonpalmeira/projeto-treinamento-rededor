data "aws_region" "current" {}

# Cria a API REST
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "API do projeto ${var.api_name}"
}

# Recurso /login
resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "login"
}

# Método POST para /login (sem autorização)
resource "aws_api_gateway_method" "login" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integração da rota /login com a Lambda de autenticação
resource "aws_api_gateway_integration" "login" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_auth_arn}/invocations"
}

# Recurso /private
resource "aws_api_gateway_resource" "private" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "private"
}
# Autorizar Cognito para /private
resource "aws_api_gateway_authorizer" "cognito" {
  name                    = "${var.api_name}-cognito"
  rest_api_id             = aws_api_gateway_rest_api.this.id
  type                    = "COGNITO_USER_POOLS"
  provider_arns           = [var.user_pool_arn]
  identity_source         = "method.request.header.Authorization"
}
# Método GET para /private (exige token Cognito)
resource "aws_api_gateway_method" "private" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.private.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}
# Integração da rota /private com a Lambda de backend
resource "aws_api_gateway_integration" "private" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.private.id
  http_method             = aws_api_gateway_method.private.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_backend_arn}/invocations"
}

# Permite que o API Gateway invoque as Lambdas
resource "aws_lambda_permission" "p_login" {
  statement_id  = "AllowInvokeLogin"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_auth_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/POST/login"
}
resource "aws_lambda_permission" "p_private" {
  statement_id  = "AllowInvokePrivate"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_backend_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/GET/private"
}

# Deployment e Stage
resource "aws_api_gateway_deployment" "this" {
  depends_on = [
    aws_api_gateway_integration.login,
    aws_api_gateway_integration.private
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  # Gatilho de "redeploy" para atualizar mudanças
  triggers = {
    redeploy = sha1(join("", [
      aws_api_gateway_integration.login.id,
      aws_api_gateway_integration.private.id
    ]))
  }
}
resource "aws_api_gateway_stage" "stage" {
  rest_api_id    = aws_api_gateway_rest_api.this.id
  deployment_id  = aws_api_gateway_deployment.this.id
  stage_name     = var.stage_name
}
