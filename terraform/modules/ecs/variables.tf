variable "aws_region" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "ecs_sg_id" {
    type = string
}

variable "execution_role_arn" {
    type = string
}

variable "image_uri" {
    type = string
}

variable "blue_target_group_arn" {
    type = string
}

variable "db_host" {

}

variable "db_password" {

}

variable "app_keys" {

}

variable "api_token_salt" {

}

variable "admin_jwt_secret" {

}

variable "jwt_secret" {

}