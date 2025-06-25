variable "project" {
  description = "Nome do projeto"
  type        = string
  default     = "api-dev-treinamento"
}

variable "env" {
  type        = string
  description = "Nome do ambiente"
  default = "dev"
}
variable "region" {
  type        = string
  description = "Região AWS"
  default = "sa-east-1"
}
