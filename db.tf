resource "aws_db_instance" "vulpydb" {
  instance_class         = "db.t3.micro"
  identifier             = "vulpy-db"
  allocated_storage      = 10
  username               = "vulpy"
  password               = "good_vulpy"
  engine                 = "mysql"
  skip_final_snapshot    = true
  db_name                = "vulpydb"
  vpc_security_group_ids = [aws_security_group.allow_vulpy_db.id]
  publicly_accessible    = true
}

resource "null_resource" "init_db" {
  provisioner "local-exec" {
    command = <<EOL
export AWS_DB_USER=${aws_db_instance.vulpydb.username} \
&& export AWS_DB_PASSWORD=${aws_db_instance.vulpydb.password} \
&& export AWS_DB_HOST=$(echo ${aws_db_instance.vulpydb.endpoint}| cut -d':' -f1) \
&& export AWS_DB_PORT=${aws_db_instance.vulpydb.port} \
&& export AWS_DB_ID=${aws_db_instance.vulpydb.id} \
&& export AWS_REGION=${var.region} \
&& python3 ./db_init_scripts/RDS_db_init.py
EOL
  }
  depends_on = [aws_db_instance.vulpydb]
}

