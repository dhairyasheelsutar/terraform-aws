# Setup our aws provider
provider "aws" {
    region = "us-east-1"
}

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "db-subnet-grp-20942"
  subnet_ids = ["subnet-040b66e757e6ca460", "subnet-03dd0c8ab10b3ca35"]

  tags = {
    Name = "db-subnet-grp-20942"
  }
}

resource "aws_db_instance" "rds_mysql_instance" {
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    name                 = "mydb"
    username             = "admin"
    password             = "Dheeraj6898"
    parameter_group_name = "default.mysql5.7"
    db_subnet_group_name = "${aws_db_subnet_group.db_subnet_grp.id}"
}

