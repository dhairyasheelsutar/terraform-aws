# Setup our aws provider
provider "aws" {
    region = "us-east-1"
}

data "template_file" "user_data" {
    template = "${file("startup_script.sh")}"
}


resource "aws_instance" "instance_20942_pub" {
    ami                    = "ami-0bcc094591f354be2"
    instance_type          = "t2.micro"
    subnet_id              = "subnet-0783890f7bd7f6efb"
    vpc_security_group_ids = ["sg-0def65b68a4abd34d"]
    user_data              = "${data.template_file.user_data.rendered}"
    key_name               = "dhairyasheel-20942-key-pair"
    associate_public_ip_address = "true"
    tags {
        Name = "20942-pub-instance"
    }
}

resource "aws_ami_from_instance" "ami_instance" {
    name               = "ami-20942"
    source_instance_id = "${aws_instance.instance_20942_pub.id}"
    tags {
        Name = "ami-20942"
    }
}
