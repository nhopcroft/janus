
resource "aws_cognito_user_pool" "pool" {
  name                = "${var.ses_domain_identity}-${var.deployment_environment}"
  deletion_protection = var.deployment_environment == "prod" ? "ACTIVE" : "INACTIVE"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length                   = 14
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address = "web@${var.ses_domain_identity}"
    reply_to_email_address = "dev@neilhopcroft.com"
    source_arn = data.aws_ses_domain_identity.email.arn
  }
  tags = local.tags
}

resource "aws_cognito_user_pool_domain" "user_pool" {
  domain       = "${var.ses_domain_identity}-${var.deployment_environment}"
  user_pool_id = aws_cognito_user_pool.devops.id
}

resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.ses_domain_identity}-${var.deployment_environment}"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "email", "profile"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls = [
    // it seems like there might be a better way to do this
    "https://www.${var.ses_domain_identity}/oauth2/callback",
    "https://www.${var.ses_domain_identity}/",
    "https://${var.ses_domain_identity}/oauth2/callback",
    "https://${var.ses_domain_identity}/",
  ]
  logout_urls = [
    "https://www.${var.ses_domain_identity}/",
    "https://${var.ses_domain_identity}/",
  ]
  explicit_auth_flows           = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"

  access_token_validity  = 60
  id_token_validity      = 60
  refresh_token_validity = 30

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}
