#####
## Network module defines the following things
# 1. Create a VPC.
# 2. Create internet gateways.
# 3. Create subnets by calling subnet module
# 4. Create route table for public subnets.
# 5. Associate route table with the subnet and attach internet gateway
# 6. Creating security groups 
#####

locals {
    allow_from_everywhere = "0.0.0.0/0"
}

# Define a vpc
resource "aws_vpc" "vpc_name" {
    cidr_block = "${var.vpc_cidr}"
    tags {
        Name = "${var.vpc_name}-${var.tag_suffix}"
    }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "demo_ig" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    tags {
        Name = "${var.igw_name}-${var.tag_suffix}"
    }
}

# Public subnet
resource "aws_subnet" "vpc_public_sn" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "${var.cidr_pub_subnet}"
    availability_zone = "${var.availibility_zone_pub_subnet}"
    tags {
        Name = "${var.pub_subnet_name}-${var.tag_suffix}"
    }
}

# Private subnet 1
resource "aws_subnet" "vpc_private_sn_1" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "${var.cidr_pri1_subnet}"
    availability_zone = "${var.availibility_zone_pri1_subnet}"
    tags {
        Name = "${var.pri1_subnet_name}-${var.tag_suffix}"
    }
}

# Private subnet 2
resource "aws_subnet" "vpc_private_sn_2" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "${var.cidr_pri2_subnet}"
    availability_zone = "${var.availibility_zone_pri2_subnet}"
    tags {
        Name = "${var.pri2_subnet_name}-${var.tag_suffix}"
    }
}

# Extra subnet created for deployment. Here is the deployment scenario
# private ec2 instance: Deployed in subnet 1
# RDS instances: Deployed in private subnet 2, subnet 3

resource "aws_subnet" "vpc_private_sn_3" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "${var.cidr_pri3_subnet}"
    availability_zone = "${var.availibility_zone_pri3_subnet}"
    tags {
        Name = "${var.pri3_subnet_name}-${var.tag_suffix}"
    }
}

# Routing table for public subnet
resource "aws_route_table" "vpc_public_sn_rt" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    route {
        cidr_block = "${local.allow_from_everywhere}"
        gateway_id = "${aws_internet_gateway.demo_ig.id}"
    }
    tags {
        Name = "${var.rt_name}-${var.tag_suffix}"
    }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "vpc_public_sn_rt_assn" {
    subnet_id = "${aws_subnet.vpc_public_sn.id}"
    route_table_id = "${aws_route_table.vpc_public_sn_rt.id}"
}

# Security group for private subnet
resource "aws_security_group" "vpc_private_sg" {
    name = "${var.sg_group_name}_${var.tag_suffix}"
    description = "${var.sg_group_desc}"
    vpc_id = "${aws_vpc.vpc_name.id}"

    # Allow ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${local.allow_from_everywhere}"]
    }

    # allow mysql port within VPC
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.cidr_pri1_subnet}"]
    }

    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["${local.allow_from_everywhere}"]
    }
    tags {
        Name = "${var.sg_group_name}"
    }
}