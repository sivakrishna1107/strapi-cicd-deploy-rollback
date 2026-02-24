output "vpc_id" {
    value = data.aws_vpc.default.id
}

output "subnet_ids" {
    value = distinct([
        for s in data.aws_subnet.selected :
        s.id if s.map_public_ip_on_launch
    ])
}