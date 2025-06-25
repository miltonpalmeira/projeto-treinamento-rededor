output "function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
    description = "ARN da função Lambda"
    value       = aws_lambda_function.this.arn  
}