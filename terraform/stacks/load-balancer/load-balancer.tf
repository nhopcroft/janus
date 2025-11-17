
resource "aws_lb" "load_balancer" {
    name = "nh-load-balancer"
    subnets = [ aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "Hello"
            status_code = "200"
        }
    }
}

resource "aws_acm_certificate" "prz378" {
  domain_name       = "prz378.com"
  validation_method = "DNS"

  subject_alternative_names = [ "*.prz378.com" ]
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "prz378" {
    name = "prz378.com"
}

resource "aws_route53_record" "prz378" {
  for_each = {
    for dvo in aws_acm_certificate.prz378.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.prz378.zone_id
}

resource "aws_acm_certificate_validation" "prz378" {
  certificate_arn         = aws_acm_certificate.prz378.arn
  validation_record_fqdns = [for record in aws_route53_record.prz378 : record.fqdn]
}
