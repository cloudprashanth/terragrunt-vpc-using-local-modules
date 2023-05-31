
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_main_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = "true"
  tags = {
    Name = "${local.project_name}-${local.env}-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.az_names)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_main_cidr, 8, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.project_name}-${local.env}-public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${local.project_name}-${local.env}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.project_name}-${local.env}-public-rt"
  }
}

resource "aws_route_table_association" "pub_sub_asociation" {
  count          = length(local.az_names)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public_rt.id
}

# resource "aws_subnet" "private" {
#   count = "${length(slice(local.az_names, 0, 2))}"
#   vpc_id = "${aws_vpc.main_vpc.id}"
#   cidr_block = cidrsubnet(var.vpc_main_cidr, 8, count.index + length(local.az_names))
#   availability_zone = local.az_names[count.index]
#   tags = {
#     Name = "${local.project_name}-${local.env}-private-subnet-${count.index +1}"
#   }
# }

# resource "aws_eip" "nat_ip" {
#   vpc      = true
#   tags = {
#     Name = "${local.project_name}-${local.env}-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = "${aws_eip.nat_ip.id}"
#   subnet_id     = "${aws_subnet.public[2].id}"

#   tags = {
#     Name = "${local.project_name}-${local.env}-nat-gw"
#   }
# }

# resource "aws_route_table" "private_rt" {
#   vpc_id = "${aws_vpc.main_vpc.id}"

#   route {
#     cidr_block  = "0.0.0.0/0"
#     gateway_id = "${aws_nat_gateway.nat_gw.id}"
#   }

#   tags = {
#     Name = "${local.project_name}-${local.env}-private-rt"
#   }
# }

# resource "aws_route_table_association" "private_rt_association" {
#   count          = "${length(slice(local.az_names, 0, 2))}"
#   subnet_id      = "${aws_subnet.private.*.id[count.index]}"
#   route_table_id = "${aws_route_table.private_rt.id}"
# }
