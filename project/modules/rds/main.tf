#####
## Rds module
#####

## subnet_ids passed as string so need to convert them into list
resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "${var.db_subnet_grp}-${var.tag_suffix}"
  subnet_ids = ["${split(";", var.db_subnet_grp_ids)}"]

  tags = {
    Name = "${var.db_subnet_grp}-${var.tag_suffix}"
  }
}

resource "aws_db_instance" "rds_mysql_instance" {
    identifier           = "${var.identifier}-${var.tag_suffix}"
    allocated_storage    = "${var.allocated_storage}"
    storage_type         = "gp2"
    engine               = "${var.db_engine}"
    engine_version       = "${var.db_engine_version}"
    instance_class       = "${var.db_instance_class}"
    name                 = "${var.db_name}"
    username             = "${var.db_user}"
    password             = "${var.db_pass}"
    skip_final_snapshot  = "${var.db_skip_final_snapshot}"
    parameter_group_name = "${var.db_parameter_group_name}"
    db_subnet_group_name = "${aws_db_subnet_group.db_subnet_grp.id}"
    vpc_security_group_ids  = ["${var.security_grp_id}"]
}