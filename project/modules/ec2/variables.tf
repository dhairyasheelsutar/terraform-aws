#####
## Variables for ec2 instance
#####

variable tag_suffix {}
variable ami_id {}
variable instance_type { default = "t2.micro" }
variable subnet_id {}
variable security_grp_id { type = "list" }
variable key_pair { default = "dhairyasheel-20942-key-pair" }
variable user_data { default = "" }
variable associate_public_ip_address { default = "true" }
variable instance_name { default = "instance" }