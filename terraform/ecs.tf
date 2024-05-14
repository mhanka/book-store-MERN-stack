resource aws_ecs_cluster "main" {
    name = "book-store-cluster"
}

data template_file "frontend_app"{
    template = file("./templates/ecs/frontend_app.json.tpl")
    vars = {
        frontend_app_image = var.frontend_app_image
        frontend_app_port = var.frontend_app_port
        fargate_cpu = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws_region = var.aws_region
    }
}

data template_file "backend_app"{
    template = file("./templates/ecs/backend_app.json.tpl")
    vars = {
        backend_app_image = var.backend_app_image
        backend_app_port = var.backend_app_port
        fargate_cpu = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws_region = var.aws_region
    }
}

resource aws_ecs_task_definition "frontend_app" {
    family = "frontend-app"
    container_definitions = data.template_file.frontend_app.rendered
    requires_compatibilities = ["FARGATE"]
    cpu = var.fargate_cpu
    memory = var.fargate_memory
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource aws_ecs_task_definition "backend_app" {
    family = "backend-app"
    container_definitions = data.template_file.backend_app.rendered
    requires_compatibilities = ["FARGATE"]
    cpu = var.fargate_cpu
    memory = var.fargate_memory
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource aws_ecs_service "frontend_app" {
    name = "frontend-app"
    cluster = aws_ecs_cluster.main.arn
    task_definition = aws_ecs_task_definition.frontend_app.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = aws_subnet.public.*.id
        security_groups = [aws_security_group.ecs_tasks.id]
        assign_public_ip = true
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.frontend_target_group.arn
        container_name = "frontend-app"
        container_port = var.frontend_app_port
    }
    depends_on = [ aws_lb_target_group.frontend_target_group, aws_iam_role.ecs_task_execution_role ]
}

resource aws_ecs_service "backend_app" {
    name = "backend-app"
    cluster = aws_ecs_cluster.main.arn
    task_definition = aws_ecs_task_definition.backend_app.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = aws_subnet.public.*.id
        security_groups = [aws_security_group.ecs_tasks.id]
        assign_public_ip = true
    }
    load_balancer {
        target_group_arn = aws_lb_target_group.backend_target_group.arn
        container_name = "backend-app"
        container_port = var.backend_app_port
    }
    depends_on = [ aws_lb_target_group.backend_target_group, aws_iam_role.ecs_task_execution_role ]
}