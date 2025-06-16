resource "aws_lambda_function" "this" {
  function_name = var.name
  handler = var.handler
  runtime = "nodejs18.x"
  role = var.role_arn
  filename = var.filename
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.env_vars
  }
}

resource "aws_log_group" "this" {
  name = "cw-lg-${aws_lambda_function.this.function_name}"
  retention_in_days = 14
}