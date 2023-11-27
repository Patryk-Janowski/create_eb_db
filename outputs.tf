output "AWS_DB_HOST" {
  value = split(":", aws_db_instance.vulpydb.endpoint)[0]  
}

output "AWS_DB_PORT" {
  value = aws_db_instance.vulpydb.port
}

output "AWS_DB_USER" {
  value = aws_db_instance.vulpydb.username
}

output "AWS_DB_PASSWORD" {
  sensitive = true
  value     = aws_db_instance.vulpydb.password
}

output "AWS_DB_ID" {
  value     = aws_db_instance.vulpydb.id
}

output "AWS_REGION" {
  value     = var.region
}
