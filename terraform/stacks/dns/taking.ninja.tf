
resource "aws_route53_zone" "taking_ninja" {
    name = "taking.ninja"
}

resource "aws_route53_record" "taking_ns" {
    zone_id = aws_route53_zone.taking_ninja
    name = "taking.ninja"
    type = "NS"
    ttl = "30"
    records = aws_route53_zone.taking_ninja.name_servers
}
