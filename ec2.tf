# Instancias EC2
resource "aws_instance" "app1" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id
  security_groups = [aws_security_group.web_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              echo "<h1>App 1 - 70%</h1>" > /var/www/html/index.html
              systemctl start apache2
              systemctl enable apache2
            EOF

  tags = { Name = "App1-s10" }
}

resource "aws_instance" "app2" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_2.id
  security_groups = [aws_security_group.web_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              echo "<h1>App 2 - 30%</h1>" > /var/www/html/index.html
              systemctl start apache2
              systemctl enable apache2
            EOF

  tags = { Name = "App2-S10" }
}