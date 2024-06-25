# variables.tf

variable "aws_access_key" {
    description = "The IAM public access key"
    sensitive = true
}

variable "aws_secret_key" {
    description = "IAM secret access key"
    sensitive = true
}

variable "aws_region" {
  default = "us-east-1"
  description = "aws region settings"
}

variable "mongodb_url"{
    description = "MongoDB url value"
    sensitive = true
}

variable "ec2_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
    description = "ECS auto scale role name"
    default = "myEcsAutoScaleRole"
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}

variable "frontend_app_image" {
     description = "Docker image to run in the ECS cluster"
     default = "mohankris1995/book-store-app:frontend-latest"
}

variable "backend_app_image" {
     description = "Docker image to run in the ECS cluster"
     default = "mohankris1995/book-store-app:backend-latest"
}
variable "frontend_app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 80

}
variable "backend_app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 5000

}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 3
}

variable "frontend_health_check_path" {
  default = "/"
}

variable "backend_health_check_path" {
  default = "/api"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}