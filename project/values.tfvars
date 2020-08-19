region                  =   "us-east-1"
vpc_cidr                =   "20.0.0.0/16"
cidr_pub_subnet         =   "20.0.1.0/24"
cidr_pri1_subnet        =   "20.0.2.0/24"
cidr_pri2_subnet        =   "20.0.3.0/24"
cidr_pri3_subnet        =   "20.0.4.0/24"

allocated_storage       =   20
db_engine               =   "mysql"
db_engine_version       =   "5.7"
db_instance_class       =   "db.t2.micro"
db_skip_final_snapshot  =   "true"
db_parameter_group_name =   "default.mysql5.7"

ami_id                  =   "ami-07ce44346a1d7354b"
instance_type           =   "t2.micro"