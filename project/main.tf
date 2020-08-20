# 1. Create VPC
# 2. Launch subnets
# 3. Create a route table.
# 4. Create internet gateway.
# 5. Assign subnet to the above route table and attach internet gateway to it.
# 6. Create AMI which is installed with mysql.
# 7. Create DB security group in the private subnet.
# 8. Launch RDS instance in subnet 2 and subnet 3.
# 9. Launch one ec2 instance in public subnet and one in private subnet 1.
# 10. Create a startup script which will connect to database and perform some crud operations.


# Setup our aws provider
provider "aws" {
    region = "${var.region}"
}

# Setting up backend to store state file
terraform {
    backend "s3" {
        bucket             =   "bucket-20942"
        key                =   "global/s3/state/"
        region             =   "us-east-1"
        encrypt            =   true
    }
}

module "network" {
    source                  =   "./modules/network"
    vpc_cidr                =   "${var.vpc_cidr}"
    cidr_pub_subnet         =   "${var.cidr_pub_subnet}"
    cidr_pri1_subnet        =   "${var.cidr_pri1_subnet}"
    cidr_pri2_subnet        =   "${var.cidr_pri2_subnet}"
    cidr_pri3_subnet        =   "${var.cidr_pri3_subnet}"
    tag_suffix              =   "${var.tag_suffix}"
}

module "rds" {
    source                  = "./modules/rds"
    db_subnet_grp_ids       =   "${module.network.db_subnet_grp_ids}"
    allocated_storage       =   "${var.allocated_storage}"
    db_engine               =   "${var.db_engine}"
    db_engine_version       =   "${var.db_engine_version}"
    db_instance_class       =   "${var.db_instance_class}"
    db_name                 =   "${var.db_name}"
    db_user                 =   "${var.db_user}"
    db_pass                 =   "${var.db_pass}"
    db_skip_final_snapshot  =   "${var.db_skip_final_snapshot}"
    db_parameter_group_name =   "${var.db_parameter_group_name}"
    security_grp_id         =   ["${module.network.security_group_id}"]
    tag_suffix              =   "${var.tag_suffix}"
}

module "public_insance" {
    source                  =   "./modules/ec2"
    ami_id                  =   "${var.ami_id}"
    instance_type           =   "${var.instance_type}"
    subnet_id               =   "${var.subnet_id}"
    security_grp_id         =   ["${module.network.security_group_id}"]
    tag_suffix              =   "${var.tag_suffix}"
}

module "private_instance" {
    source                  =   "./modules/ec2"
    tag_suffix              =   "${var.tag_suffix}"
    ami_id                  =   "${var.ami_id}"
    instance_type           =   "${var.instance_type}"
    subnet_id               =   "${var.subnet_id}"
    security_grp_id         =   ["${module.network.security_group_id}"]
    user_data               =   <<-EOF
                            #!/bin/bash
                            mysql -h ${module.rds.host} -u ${var.db_user} -p${var.db_pass} ${var.db_name} \
                            -e "create table if not exists test(id int, name varchar(255)); 
                            insert into test values (1, 'dhiraj'), (2, 'johndoe');"                   
                            EOF
    associate_public_ip_address = "false"
}
