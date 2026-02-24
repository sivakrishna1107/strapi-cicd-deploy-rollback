# Application Load Balancer
resource "aws_lb" "strapi_alb" {
    name               = "strapi-alb-jayani"
    load_balancer_type = "application"
    subnets            = var.subnet_ids
    security_groups    = [var.alb_sg_id]
}

# Blue Target Group
resource "aws_lb_target_group" "blue" {
    name        = "strapi-blue-jayani"
    port        = 1337
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "ip"

    health_check {
        path                = "/_health"
        matcher             = "200"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

# Green Target Group
resource "aws_lb_target_group" "green" {
    name        = "strapi-green-jayani"
    port        = 1337
    protocol    = "HTTP"
    vpc_id      = var.vpc_id
    target_type = "ip"

    health_check {
        path                = "/_health"
        matcher             = "200"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

# Listener (initially forwarding to Blue)
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.strapi_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.blue.arn
    }
}