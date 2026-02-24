resource "aws_ecs_cluster" "strapi_cluster" {
    name = "strapi-cluster-jayani"
}

resource "aws_ecs_task_definition" "strapi" {
    family                   = "strapi-task"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = "512"
    memory                   = "1024"
    execution_role_arn       = var.execution_role_arn

    container_definitions = jsonencode([
        {
        name  = "strapi"
        image = "nginx:latest"
        portMappings = [{
            containerPort = 1337
            hostPort      = 1337
        }]
        }
    ])
}

resource "aws_ecs_service" "strapi_service" {
    name            = "strapi-service"
    cluster         = aws_ecs_cluster.strapi_cluster.id
    task_definition = aws_ecs_task_definition.strapi.arn
    desired_count   = 2
    launch_type     = "FARGATE"

    deployment_controller {
        type = "CODE_DEPLOY"
    }

    network_configuration {
        subnets         = var.subnet_ids
        security_groups = [var.ecs_sg_id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = var.blue_target_group_arn
        container_name   = "strapi"
        container_port   = 1337
    }
}