
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

resource "aws_ses_domain_dkim" "domain" {
  domain = aws_ses_domain_identity.email.domain
}

resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.domain.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.domain.dkim_tokens[count.index]}.dkim.amazonses.com"]
}
