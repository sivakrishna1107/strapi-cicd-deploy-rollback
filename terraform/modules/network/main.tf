data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "aws_subnet" "details" {
    for_each = toset(data.aws_subnets.default.ids)
    id       = each.value
}

locals {
    public_subnets_by_az = {
        for s in data.aws_subnet.details :
        s.availability_zone => s.id
        if s.map_public_ip_on_launch
    }
}