
output "TF_VAR_domain" {
    value = var.domain
}
output "TF_VAR_zone_id" {
    value = aws_route53_zone.domain.zone_id
}
