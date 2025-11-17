
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
