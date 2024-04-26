# network.tf

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/24"
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_subnet" "private" {
    count             = var.az_count
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.main.id
}

resource "aws_subnet" "public" {
    count                   = var.az_count
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    count  = var.az_count
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
    count      = var.az_count
    domain = "vpc"
    depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
    count         = var.az_count
    allocation_id = aws_eip.gw[count.index].id
    subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    count  =  var.az_count
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
    }    
} 

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
    count          = var.az_count
    subnet_id      = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}