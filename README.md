# Projeto AWS API Gateway + Lambda + Cognito (DEV)

## Estrutura de Pastas

- `.azure-pipelines/`: Pipelines de CI/CD.
- `docs/`: Documentação técnica.
- `lambda/`: Código das funções Lambda.
- `packages/`: Bibliotecas internas (se houver).
- `terraform/`: Infraestrutura como código.

## Como Inicializar o Projeto

1. **Clonar o repositório:**

```bash
git clone https://seurepositorio.git
cd nome-do-projeto

2. **Configurar ambiente local:**

Copie o .env.example para .env e preencha com seus dados.

```bash
cp .env.example .env

3. **Instalar dependências para Lambda:**

```bash
npm install

4. **Inicializar Terraform:**

```bash
cd terraform/envs/dev
terraform init

5. **Validar Terraform:**

```bash
terraform validate

6. **Criar infraestrutura:**

```bash
terraform apply