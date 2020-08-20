### Variables for main file

variable "region" { default = "us-east-1" }
variable "tag_suffix" {}

# Variables defined for network module
variable "vpc_cidr" {}
variable "cidr_pub_subnet" {}
variable "cidr_pri1_subnet" {}
variable "cidr_pri2_subnet" {}
variable "cidr_pri3_subnet" {}

# Variables defined for RDS module
variable "db_subnet_grp_ids" {}
variable "allocated_storage" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_instance_class" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "db_parameter_group_name" {}
variable "db_skip_final_snapshot" {}
variable "security_grp_id" {}

# Variables defined for ec2 module
variable "ami_id" {}
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" {}
variable "key_pair" { default = "dhairyasheel-20942-key-pair" }
variable "user_data" { default = "" }
variable "associate_public_ip_address" { default = "true" }
variable "instance_name" { default = "instance" }