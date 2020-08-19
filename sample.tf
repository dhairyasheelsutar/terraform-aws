# Setup our aws provider
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "instance_20942_pub" {
    ami                    = "ami-0bcc094591f354be2"
    instance_type          = "t2.micro"
    subnet_id              = "subnet-0783890f7bd7f6efb"
    vpc_security_group_ids = ["sg-0def65b68a4abd34d"]
    user_data              = "#! /bin/bash
                            sudo apt-get update -y
                            sudo apt-get install mysql-client -y"
    key_name               = "dhairyasheel-20942-key-pair"
    associate_public_ip_address = "true"
    tags {
        Name = "20942-pub-instance"
    }
}

