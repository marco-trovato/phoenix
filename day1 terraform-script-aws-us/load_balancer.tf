resource "aws_lb" "lb" {
  name               = "${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public.*.id
}


resource "aws_lb_target_group" "target_logic" {
  name        = "${var.app_name}-target-logic"
  port        = var.server_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_lb.lb]

  health_check {
    enabled = true
    path    = "/"
  }
}

resource "aws_lb_listener" "logic" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_logic.arn
  }
}

resource "aws_lb_target_group_attachment" "logic-target-group-attachement" {
  target_group_arn = aws_lb_target_group.target_logic.arn
  target_id        = aws_instance.server.id
  port             = "80"
}

