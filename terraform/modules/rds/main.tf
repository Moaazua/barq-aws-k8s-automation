#######################
# RDS DB Subnet Group #
#######################
resource "aws_db_subnet_group" "main" {
  name        = "barq-db-subnet-group"
  description = "Private subnets for BARQ PostgreSQL"

  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "barq-db-subnet-group"
  }
}
###########################
# PostgreSQL RDS Instance #
###########################
resource "aws_db_instance" "postgres" {
  identifier = "barq-postgres"

  engine         = "postgres"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = "barqdb"
  username = "barqadmin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "barq-postgres"
  }
}

