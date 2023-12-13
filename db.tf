resource "aws_db_instance" "vulpydb" {
  instance_class         = "db.t3.micro"
  identifier             = "vulpy-db"
  snapshot_identifier    = "vulpy-db-initial"
  allocated_storage      = 10
  username               = "vulpy"
  password               = "good_vulpy"
  engine                 = "mysql"
  skip_final_snapshot    = true
  db_name                = "vulpydb"
  vpc_security_group_ids = [aws_security_group.allow_vulpy_db.id]
  publicly_accessible    = false
}

