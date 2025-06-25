variable "project" {
  type       = string
  description = "Nome do projeto, usado no prefixo dos recursos"
}

variable "env" {
  type = string
  description = "Nome do ambiente: dev, hml, prd"
}