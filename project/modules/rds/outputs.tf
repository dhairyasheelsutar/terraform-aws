#####
## Outputs file for rds module
## 1. MySQL host
#####
output "host" {
    value = "${aws_db_instance.rds_mysql_instance.address}"
}