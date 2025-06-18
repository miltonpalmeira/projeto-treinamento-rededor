# Nome da função Lambda
variable "name" {
  description = "Nome da função Lambda"
  type        = string
}

# Handler padrão da Lambda, por exemplo 'index.handler'
variable "handler" {
  description = "Handler da Lambda (arquivo.método)"
  type        = string
}

# ARN da Role IAM que a Lambda vai assumir (permissões)
variable "role_arn" {
  description = "ARN da IAM Role que será associada à Lambda"
  type        = string
}

# Caminho para o arquivo ZIP da função Lambda
variable "filename" {
  description = "Caminho para o arquivo ZIP com o código da Lambda"
  type        = string
}

# Variáveis de ambiente que a Lambda vai usar
variable "env_vars" {
  description = "Variáveis de ambiente para a Lambda"
  type    = map(string)
  default = {}
}