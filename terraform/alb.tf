# alb.tf

resource "aws_alb" "main" {
    name        = "bk-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "frontend_target_group" {
    name     = "bk-target-group-frontend"
    port     = var.frontend_app_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.main.id
    target_type = "ip"
   health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path = var.frontend_health_check_path
        unhealthy_threshold = "2"
    }
}

resource "aws_lb_target_group" "backend_target_group" {
    name     = "bk-target-group-backend"
    port     = var.backend_app_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.main.id
    target_type = "ip"
    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path = var.backend_health_check_path
        unhealthy_threshold = "2"
    }
}
resource "aws_lb_listener" "front_end_listener" {
    load_balancer_arn = aws_alb.main.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.frontend_target_group.arn
    }
}

resource "aws_lb_listener" "back_end_listener" {
    load_balancer_arn = aws_alb.main.arn
    port              = "5000"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.backend_target_group.arn
    }
}