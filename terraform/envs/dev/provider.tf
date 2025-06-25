locals {
  default_tags = {
    rdsl-environment = var.env
    rdsl-costshared  = "não"
    rdsl-costcenter  = "CC12345"
    rdsl-application = "Treinamento-milton-pameira"
    rdsl-project     = var.project
    rdsl-equipe-resp = "Engenharia"
    ManagedBy        = "Terraform"
    Email            = "engsw@rededor.com.br"
    Owner            = "Engenharia"
    rdsl-owner       = "Engenharia"
  }
}


provider "aws" {
  region = var.region

  default_tags {
    tags = local.default_tags
  }
}
