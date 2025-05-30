# Load Balancer (Application Load Balancer)
resource "aws_lb" "alb" {
  name               = "simple-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups    = [aws_security_group.web_sg.id]
  tags = {
    Name = "alb-s10"
  }
}

# Target Groups
# App1
resource "aws_lb_target_group" "tg_app1" {
  name     = "tg-app1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }


  tags = {
    Name = "tg-app1-s10"
  }
}

# App2
resource "aws_lb_target_group" "tg_app2" {
  name     = "tg-app2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-app2-s10"
  }
}

# Registrar instancias
# App1
resource "aws_lb_target_group_attachment" "attach_app1" {
  target_group_arn = aws_lb_target_group.tg_app1.arn
  target_id        = aws_instance.app1.id
  port             = 80
}

# App2
resource "aws_lb_target_group_attachment" "attach_app2" {
  target_group_arn = aws_lb_target_group.tg_app2.arn
  target_id        = aws_instance.app2.id
  port             = 80
}

# Listener con regla 70/30
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group { # App1
        arn    = aws_lb_target_group.tg_app1.arn
        weight = 70
      }

      target_group { # App2
        arn    = aws_lb_target_group.tg_app2.arn
        weight = 30
      }
    }
  }
  tags = {
    Name = "listener-lb-s10"
  }
}