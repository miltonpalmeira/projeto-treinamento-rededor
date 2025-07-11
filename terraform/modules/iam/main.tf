# Criação da Role IAM para a Lambda
resource "aws_iam_role" "lambda_exec" {
  name = var.name

  # Política de confiança: permite que a Lambda assuma essa role
  assume_role_policy = jsondecode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}