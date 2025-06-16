provider "aws" {
  region = "sa-east-1"
}

module "iam_lambda_auth" {
  source = "../../modules/iam"
  name = "role-auth-dev"
}

module "lambda_auth" {
  source = "../../modules/lambda"
  name = "lambda-auth-dev"
  handler = "index.handler"
  filename = "${path.module}/../../packages/lambda-auth/dist/lambda-auth.zip"
  role_arn   = module.iam_lambda_auth.arn
  env_vars   = { COGNITO_USER_POOL_ID = module.cognito.user_pool_id }
}