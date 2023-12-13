data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_vulpy_db" {
  name        = "allow_vulpy_db"
  description = "Allow traffic from vulpy to RDS DB"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}