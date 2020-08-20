#####
## Outputs file returns
# 1. Vpc id
# 2. Subnet ids
# 3. Security group id
#####

output "vpc_id" {
    value = "${aws_vpc.vpc_name.id}"
}

output "db_subnet_grp_ids" {
    value = "${aws_subnet.vpc_private_sn_2.id};${aws_subnet.vpc_private_sn_3.id}"
}

output "public_instance_subnet_id" {
    value = "${aws_subnet.vpc_public_sn.id}"
}

output "private_instance_subnet_id" {
    value = "${aws_subnet.vpc_private_sn_1.id}"
}

output "security_group_id" {
    value = "${aws_security_group.vpc_private_sg.id}"
}
