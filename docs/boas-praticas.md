# Boas Práticas

## Desenvolvimento
- Use `.env` para variáveis sensíveis.
- Estruture o código com pastas `packages/lambda-<nome>`.
- Evite hardcoded: use `process.env`.

## Terraform
- Nomenclatura seguindo padrão: `lambda-dev-gts-backend`
- Separar módulos reutilizáveis em `terraform/modules/`
- Usar `terraform/stacks/dev/main.tf` para stack do ambiente.

## Lambda
- Mantenha as Lambdas pequenas e focadas.
- Inclua tratamento de erro com logs padronizados.
