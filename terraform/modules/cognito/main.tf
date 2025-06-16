resource "cognito_user_pool" "this" {
  name = var.name

  auto_verified_attributes = var.auto_verified_attributes

  password_policy {
    minimum_length = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers = true
    require_symbols = false
  }
}

resource "cognito_user_pool_client" "client" {
  name = "${var.name}-client"
  user_pool_id = cognito_user_pool.this.id

  generate_secret = false
}