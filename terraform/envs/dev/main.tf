module "cognito" {
  source = "../../modules/cognito"
  project = var.project
  env     = var.env
}

module "lambda_auth" {
  source = "../../modules/lambda"
  function_name = "lambda-${var.env}-${var.project}-auth"
  handler       = "dist/index.handler"
  runtime       = "nodejs18.x"
  source_dir    = "${path.root}/../../packages/lambda-auth/dist"
  # Variáveis de ambiente para o módulo
  user_pool_id  = module.cognito.user_pool_id
  client_id     = module.cognito.user_pool_client_id
}

module "lambda-backend" {
  source = "../../modules/lambda"
  function_name = "lambda-${var.env}-${var.project}-backend"
  handler       = "dist/index.handler"
  runtime       = "nodejs18.x"
  source_dir    = "${path.root}/../../packages/lambda-backend/dist"
}

module "api-gateway" {
  source = "../../modules/api-gateway"
  api_name = "api-${var.env}-${var.project}-auth"
  stage_name = var.env
  lambda_auth_arn = module.lambda_auth.lambda_arn
  lambda_backend_arn = module.lambda-backend.lambda_arn
  user_pool_arn = module.cognito.user_pool_arn  
}