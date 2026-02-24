output "vpc_id" {
    value = data.aws_vpc.default.id
}

output "subnet_ids" {
    value = values(local.public_subnets_by_az)
}