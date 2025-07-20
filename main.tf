provider "aws" {
    region = "us-east-2"
}

resource "aws_security_group" "my-security-group" {
  name        = "my-security-group"
  description = "My security group"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0d1b5a8c13042c939"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-security-group.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}