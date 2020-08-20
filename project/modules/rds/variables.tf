#####
## Variables file for RDS in multiple subnets
#####

# Variables for creating db subnet group
variable tag_suffix {}
variable db_subnet_grp { default = "db-subnet-grp" }
variable db_subnet_grp_ids { type = "list" }

# Variables for launching RDS instance.
variable identifier { default = "rds-db" }
variable allocated_storage {}
variable db_engine {}
variable db_engine_version {}
variable db_instance_class {}
variable db_name {}
variable db_user {}
variable db_pass {}
variable db_skip_final_snapshot { default = "false" }
variable db_parameter_group_name {}
variable security_grp_id { type = "list" }