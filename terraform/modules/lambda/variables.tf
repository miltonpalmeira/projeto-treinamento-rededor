variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
}

# Handler padrão da Lambda, por exemplo 'index.handler'
variable "handler" {
  description = "Handler da Lambda (arquivo.export)"
  type        = string
}

variable "runtime" {
  description = "Runtime da função Lambda (ex: nodejs18.x)"
  type        = string
}

variable "source_dir" {
  type        = string
  description = "Diretório de origem do código da função Lambda"
}

variable "user_pool_id" {
  type        = string
  description = "ID do Cognito User Pool (para auth Lambda)"
  default = ""
}
variable "client_id" {
  type        = string
  description = "Client ID do Cognito (para auth Lambda)"
  default = ""
}
