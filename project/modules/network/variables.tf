####
## Variables file for module subnet
####

variable tag_suffix {}

# Vpc variables
variable vpc_name { default = "vpc" }
variable vpc_cidr {}

# Variable for internet gateway
variable igw_name { default = "igw" }

# Variables for route table
variable rt_name { default = "rt" }

# Variables for public subnet
variable cidr_pub_subnet {}
variable availibility_zone_pub_subnet { default = "us-east-1a" }
variable pub_subnet_name { default = "pub"}

# Variables for private subnet 1
variable cidr_pri1_subnet {}
variable availibility_zone_pri1_subnet { default = "us-east-1b" }
variable pri1_subnet_name { default = "pri1" }

# Variables for private subnet 2
variable cidr_pri2_subnet {}
variable availibility_zone_pri2_subnet { default = "us-east-1c" }
variable pri2_subnet_name { default = "pri2" }

# Variables for private instance 3
variable cidr_pri3_subnet {}
variable availibility_zone_pri3_subnet { default = "us-east-1d" }
variable pri3_subnet_name { default = "pri3" }

# Variables for security group
variable sg_group_name { default = "sg_private" }
variable sg_group_desc { default = "A security group which allows to communicate ec2 instance with the RDS." }