# Empacota o código compilado em ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = var.source_dir
  source_dir  = "${var.function_name}.zip"
}

# Cria a role do IAM para a função Lambda
resource "aws_iam_role" "this" {
  name = "role-${var.function_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })  
}

# Anexa a política básica de execução para Lambda (logs no CloudWatch)
resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Para Lambda Auth: permissão de chamar Cognito
resource "aws_iam_role_policy" "cognito" {
  count = contains(var.function_name, "auth") ? 1 : 0
  name = "policy-${var.function_name}-cognito"
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version="2012-10-17",
    Statement=[{
      Effect = "Allow",
      Action = ["cognito-idp:AdminInitiateAuth","cognito-idp:AdminUserGlobalSignOut"],
      Resource = "*"
    }]
  })
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.this.arn
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  # Variáveis de ambiente para Lambda Auth
  dynamic environment {
    # só gera se user_pool_id e client_id não estiverem vazios
    for_each = (var.user_pool_id != "" && var.client_id != "") ? [1] : []
    content {
      variables = {
        USER_POOL_ID = var.user_pool_id
        CLIENT_ID    = var.client_id
      }
    }
  }
}