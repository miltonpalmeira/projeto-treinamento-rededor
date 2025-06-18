# Cria a função Lambda na AWS
resource "aws_lambda_function" "this" {
  function_name = var.name
  handler = var.handler
  runtime = "nodejs18.x"
  role = var.role_arn
  filename = var.filename

  # Garante que o deploy da função ocorra só se o hash do arquivo mudar
  source_code_hash = filebase64sha256(var.filename)

  # Variáveis de ambiente da Lambda (como secrets, configs)
  environment {
    variables = var.env_vars
  }
}

# Cria um grupo de logs no CloudWatch para a Lambda
resource "aws_log_group" "this" {
  name = "cw-lg-${aws_lambda_function.this.function_name}"
  retention_in_days = 14
}