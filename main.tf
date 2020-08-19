# 1. Create VPC
# 2. Launch subnets
# 3. Create a route table.
# 4. Create internet gateway.
# 5. Assign subnet to the above route table and attach internet gateway to it.
# 6. Launch ec2 instance in public subnet.
# 7. Launch ec2 instance in private subnet.
# 8. Launch RDS instance in private subnet.
# 9. Connect ec2 with RDS instance.

# Setup our aws provider
provider "aws" {
  region = "us-east-1"
}

# Define a vpc
resource "aws_vpc" "vpc_name" {
  cidr_block = "20.0.0.0/16"
  tags {
    Name = "vpc-20942"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "demo_ig" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  tags {
    Name = "igw-20942"
  }
}

# Public subnet
resource "aws_subnet" "vpc_public_sn" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  cidr_block = "20.0.1.0/24"
  tags {
    Name = "pub-20942"
  }
}

# Private subnet 1
resource "aws_subnet" "vpc_private_sn_1" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  cidr_block = "20.0.2.0/24"
  tags {
    Name = "pvt-20942-1"
  }
}

# Private subnet 2
resource "aws_subnet" "vpc_private_sn_2" {
  vpc_id = "${aws_vpc.vpc_name.id}"
  cidr_block = "20.0.3.0/24"
  tags {
    Name = "pvt-20942-2"
  }

# Routing table for public subnet
resource "aws_route_table" "vpc_public_sn_rt" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.demo_ig.id}"
    }
    tags {
        Name = "rt-20942"
    }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "vpc_public_sn_rt_assn" {
    subnet_id = "${aws_subnet.vpc_public_sn.id}"
    route_table_id = "${aws_route_table.vpc_public_sn_rt.id}"
}

resource "aws_security_group" "vpc_private_sg" {
  name = "sg_private_20942"
  description = "demo security group to access private ports"
  vpc_id = "${aws_vpc.vpc_name.id}"

  # allow mysql port within VPC
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [
      "20.0.2.0/24"
    ]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "sg_private_20942"
  }
}
