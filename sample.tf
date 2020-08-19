# Setup our aws provider
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "instance_20942_pub" {
    ami                    = "ami-07ce44346a1d7354b"
    instance_type          = "t2.micro"
    subnet_id              = "subnet-0783890f7bd7f6efb"
    vpc_security_group_ids = ["sg-0def65b68a4abd34d"]
    key_name               = "dhairyasheel-20942-key-pair"
    associate_public_ip_address = "true"
    tags {
        Name = "20942-pub-instance"
    }
}


resource "aws_instance" "instance_20942_pri" {
    ami                    = "ami-07ce44346a1d7354b"
    instance_type          = "t2.micro"
    subnet_id              = "subnet-040b66e757e6ca460"
    vpc_security_group_ids = ["sg-0def65b68a4abd34d"]
    key_name               = "dhairyasheel-20942-key-pair"
    user_data              = <<-EOF
                             #!/bin/bash
                             mysql -h terraform-20200819142543857200000001.csaruqlxxway.us-east-1.rds.amazonaws.com -u admin -p
                            EOF
    tags {
        Name = "20942-pvt-instance"
    }
}

