module "network" {
    source = "./modules/network"
}

module "security" {
    source = "./modules/security"
    vpc_id = module.network.vpc_id
}

module "alb" {
    source      = "./modules/alb"
    vpc_id      = module.network.vpc_id
    subnet_ids  = module.network.subnet_ids
    alb_sg_id   = module.security.alb_sg_id
}

module "ecs" {
    source = "./modules/ecs"

    subnet_ids            = module.network.subnet_ids
    ecs_sg_id             = module.security.ecs_sg_id
    execution_role_arn    = var.execution_role_arn
    image_uri             = var.image_uri
    blue_target_group_arn = module.alb.blue_tg_arn
}

module "codedeploy" {
    source = "./modules/codedeploy"

    cluster_name        = module.ecs.cluster_name
    service_name        = module.ecs.service_name
    blue_tg_name        = module.alb.blue_tg_name
    green_tg_name       = module.alb.green_tg_name
    listener_arn        = module.alb.listener_arn
    codedeploy_role_arn = var.codedeploy_role_arn
}