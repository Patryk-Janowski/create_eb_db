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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "restrict_db_access_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_vulpy_db.id
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
  depends_on        = [null_resource.init_db]
}

resource "aws_security_group_rule" "restrict_db_access_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
  security_group_id = aws_security_group.allow_vulpy_db.id
  depends_on        = [null_resource.init_db]
}