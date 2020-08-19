# 1. Create VPC
# 2. Launch subnets
# 3. Create a route table.
# 4. Create internet gateway.
# 5. Assign subnet to the above route table and attach internet gateway to it.
# 6. Launch ec2 instance in public subnet.
# 7. Create a startup script which will install mysql in ec2 with public subnet.
# 8. Create AMI of it.
# 9. Use this ami to launch ec2 instance in private subnet.
# 10. Create DB security group in the private subnet.
# 11. Launch RDS instance in private subnet.

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
    availability_zone = "us-east-1a"
    tags {
        Name = "pub-20942"
    }
}

# Private subnet 1
resource "aws_subnet" "vpc_private_sn_1" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "20.0.2.0/24"
    availability_zone = "us-east-1b"
    tags {
        Name = "pvt-20942-1"
    }
}

# Private subnet 2
resource "aws_subnet" "vpc_private_sn_2" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "20.0.3.0/24"
    availability_zone = "us-east-1c"
    tags {
        Name = "pvt-20942-2"
    }
}

# Private subnet 3
resource "aws_subnet" "vpc_private_sn_3" {
    vpc_id = "${aws_vpc.vpc_name.id}"
    cidr_block = "20.0.4.0/24"
    availability_zone = "us-east-1d"
    tags {
        Name = "pvt-20942-3"
    }
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
  name = "sg_20942_private"
  description = "demo security group to access private ports"
  vpc_id = "${aws_vpc.vpc_name.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow mysql port within VPC
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["20.0.2.0/24"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "sg_20942_private"
  }
}

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "db-subnet-grp-20942"
  subnet_ids = ["${aws_subnet.vpc_private_sn_2.id}", "${aws_subnet.vpc_private_sn_3.id}"]

  tags = {
    Name = "db-subnet-grp-20942"
  }
}

resource "aws_db_instance" "rds_mysql_instance" {
    identifier           = "mysql-20942-instance"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    name                 = "mydb"
    username             = "admin"
    password             = "Dheeraj6898"
    skip_final_snapshot  = "true"
    parameter_group_name = ""
    db_subnet_group_name = "${aws_db_subnet_group.db_subnet_grp.id}"
    vpc_security_group_ids  = ["${aws_security_group.vpc_private_sg.id}"]
}

resource "aws_instance" "instance_20942_pub" {
    ami                    = "ami-07ce44346a1d7354b"
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.vpc_public_sn.id}"
    vpc_security_group_ids = ["${aws_security_group.vpc_private_sg.id}"]
    key_name               = "dhairyasheel-20942-key-pair"
    associate_public_ip_address = "true"
    tags {
        Name = "20942-pub-instance"
    }
}


resource "aws_instance" "instance_20942_pri" {
    ami                    = "ami-07ce44346a1d7354b"
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.vpc_private_sn_1.id}"
    vpc_security_group_ids = ["${aws_security_group.vpc_private_sg.id}"]
    key_name               = "dhairyasheel-20942-key-pair"
    user_data              = <<-EOF
                            #!/bin/bash
                            mysql -h mysql-20942-instance.csaruqlxxway.us-east-1.rds.amazonaws.com -u admin -pDheeraj6898 mydb \
                            -e "create table if not exists test(id int, name varchar(255)); 
                            insert into test values (1, 'dhiraj'), (2, 'johndoe');"                   
                            EOF
    tags {
        Name = "20942-pvt-instance"
    }
}
