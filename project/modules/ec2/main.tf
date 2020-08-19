resource "aws_instance" "instance_subnet" {
    ami                    = "${var.ami_id}"
    instance_type          = "${var.instance_type}"
    subnet_id              = "${var.subnet_id}"
    vpc_security_group_ids = "${var.security_grp_id}"
    key_name               = "${var.key_pair}"
    user_data              = "${var.user_data}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    tags {
        Name = "${var.instance_name}-${tag_suffix}"
    }
}