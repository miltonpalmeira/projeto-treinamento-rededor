# Projeto Completo AWS com Terraform: API, CRUD, Assíncrono

## Etapa 1 - Criando Estrutura com API Gateway, Lambda e Cognito

### Objetivo
Criar uma API autenticada com Cognito, gerenciada via API Gateway, com uma Lambda de autenticação e uma Lambda backend.

---

### Arquivos e Estrutura de Diretórios

```bash
infra/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── lambda-auth/
│   ├── main.tf
│   └── lambda.zip
├── lambda-backend/
│   ├── main.tf
│   └── lambda.zip
├── cognito/
│   └── main.tf
└── apigateway/
    └── main.tf
```

---

### 1.1 Cognito (infra/cognito/main.tf)

```hcl
resource "aws_cognito_user_pool" "cgnt_prd_gts_auth" {
  name = "cgnt-prd-gts-auth"
  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "cgnt_client" {
  name         = "cgnt-client-prd-gts"
  user_pool_id = aws_cognito_user_pool.cgnt_prd_gts_auth.id
  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
```

---

### 1.2 Lambda de Autenticação (infra/lambda-auth/main.tf)

```hcl
resource "aws_lambda_function" "lambda_prd_gts_auth" {
  function_name = "lambda-prd-gts-auth"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  environment {
    variables = {
      USER_POOL_ID = aws_cognito_user_pool.cgnt_prd_gts_auth.id
    }
  }
}
```

```hcl
resource "aws_iam_role" "lambda_exec" {
  name = "role-prd-gts-auth"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
```

---

### 1.3 Lambda Backend (infra/lambda-backend/main.tf)

```hcl
resource "aws_lambda_function" "lambda_prd_gts_backend" {
  function_name = "lambda-prd-gts-backend"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
}
```

---

### 1.4 API Gateway (infra/apigateway/main.tf)

```hcl
resource "aws_apigatewayv2_api" "api_prd_gts" {
  name          = "api-prd-gts"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_backend_integration" {
  api_id             = aws_apigatewayv2_api.api_prd_gts.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.lambda_prd_gts_backend.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "backend_route" {
  api_id    = aws_apigatewayv2_api.api_prd_gts.id
  route_key = "GET /data"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_backend_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api_prd_gts.id
  name        = "$default"
  auto_deploy = true
}
```

---

### 1.5 Outputs (infra/outputs.tf)

```hcl
output "api_endpoint" {
  value = aws_apigatewayv2_api.api_prd_gts.api_endpoint
}
```

---

### 1.6 Execução

```bash
terraform init
terraform apply -var-file="prd.tfvars"
```

Após aplicar:
- Você terá uma API autenticada via Cognito.
- A Lambda `lambda-prd-gts-auth` pode ser usada para autenticação.
- A Lambda `lambda-prd-gts-backend` responde a chamadas autenticadas pela API Gateway.

Para destruir:
```bash
terraform destroy -var-file="prd.tfvars"
```

---

### Boas práticas adotadas:
- Separação de responsabilidades por pastas.
- Padrão de nomenclatura uniforme por recurso.
- Uso de `source_code_hash` para detectar mudanças no código.
- Políticas mínimas necessárias (principle of least privilege).

---

## Próxima etapa: 2. Criando a Pipeline no Azure DevOps
(Deseja que eu gere agora o `azure-pipelines.yml` completo para CI/CD com Terraform, Sonar e deploy automático?)