resource "aws_ecs_cluster" "strapi_cluster" {
    name = "strapi-cluster-jayani"
}

resource "aws_ecs_task_definition" "strapi" {
    family                   = "strapi-task-jayani"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = "512"
    memory                   = "1024"
    execution_role_arn       = var.execution_role_arn

    container_definitions = jsonencode([
    {
        name  = "strapi"
        image = var.image_uri

        portMappings = [{
        containerPort = 1337
        hostPort      = 1337
        }]

        environment = [
            { name = "HOST", value = "0.0.0.0" },
            { name = "PORT", value = "1337" },
            { name = "DATABASE_CLIENT", value = "postgres" },
            { name = "DATABASE_HOST", value = var.db_host },
            { name = "DATABASE_PORT", value = "5432" },
            { name = "DATABASE_NAME", value = "strapi" },
            { name = "DATABASE_USERNAME", value = "strapiadmin" },
            { name = "DATABASE_PASSWORD", value = var.db_password },

            { name = "APP_KEYS", value = var.app_keys },
            { name = "API_TOKEN_SALT", value = var.api_token_salt },
            { name = "ADMIN_JWT_SECRET", value = var.admin_jwt_secret },
            { name = "JWT_SECRET", value = var.jwt_secret }
        ]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-group         = "/ecs/strapi-jayani"
                awslogs-region        = var.aws_region
                awslogs-stream-prefix = "ecs"
                awslogs-create-group = "true"
            }
        }
    }
    ])
}

resource "aws_ecs_service" "strapi_service" {
    name            = "strapi-service-jayani"
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