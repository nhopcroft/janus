
resource "aws_ses_domain_identity" "email" {
  domain = var.domain
}

resource "aws_route53_record" "email_verification" {
  zone_id = var.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.email.domain}"
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.email.verification_token]
}

resource "aws_ses_domain_identity_verification" "email" {
  domain = aws_ses_domain_identity.email.domain
  depends_on = [aws_route53_record.email_verification]
}
