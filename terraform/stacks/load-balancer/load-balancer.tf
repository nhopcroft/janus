
resource "aws_lb" "load_balancer" {
    name = "nh-load-balancer"
    subnets = [ aws_subnet.public_a.id, aws_subnet.public_b.id]
}
