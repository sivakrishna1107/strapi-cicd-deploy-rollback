output "vpc_id" {
    value = data.aws_vpc.default.id
}

output "subnet_ids" {
    value = slice(local.public_subnets, 0, 2)
}