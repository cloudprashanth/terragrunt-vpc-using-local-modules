output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

# output "private_subnets" {
#   value = "${aws_subnet.private.*.id}"
# }

# output "nat_ip" {
#   value = "${aws_eip.nat_ip.public_ip}"
# }

output "web_sg" {
  value = aws_security_group.web_sg.id
}
