provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "bucket-20942"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}


resource "aws_instance" "instance_20942_pub" {
    ami                    = "ami-07ce44346a1d7354b"
    instance_type          = "t2.micro"
    key_name               = "dhairyasheel-20942-key-pair"
    associate_public_ip_address = "true"
    tags {
        Name = "20942-pub-instance"
    }
}