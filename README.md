# Projeto AWS API Gateway + Lambda + Cognito (DEV)

## Etapa 1

## Estrutura de Pastas

- `.azure-pipelines/`: Pipelines de CI/CD.
- `docs/`: Documentação técnica.
- `packages/`: Lambdas.
- `terraform/`: Infraestrutura como código.

### Esta etapa do projeto cria uma API REST usando API Gateway, Lambda e Cognito, com autenticação protegendo uma rota `/private`.

## 🔧 Estrutura

- **Lambda 1 (`lambda-auth`)**: realiza login no Cognito.
- **Lambda 2 (`lambda-backend`)**: responde "Backend funcionando com sucesso!", exige token Cognito.
- **API Gateway**: expõe endpoints `/login` e `/private`.
- **Cognito User Pool**: utilizado como Authorizer no API Gateway.

---

## 🚀 Deploy na AWS

### Pré-requisitos

- AWS CLI configurado (`aws configure`)
- Terraform instalado (`terraform -v`)
- Conta Cognito já criada (ou use o Terraform opcional para isso)

## Como Inicializar o Projeto

1. **Clonar o repositório:**

```bash
git clone https://seurepositorio.git
cd nome-do-projeto

2. **Configurar ambiente local:**

Copie o .env.example para .env e preencha com seus dados.

3. **Instalar dependências para Lambda:**

```bash
npm install

4. **Inicializar Terraform:**

```bash
cd terraform/envs/dev
terraform init

5. **Validar Terraform:**

```bash
terraform plan

6. **Criar infraestrutura:**

```bash
terraform apply