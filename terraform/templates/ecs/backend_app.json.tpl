[
  {
    "name": "backend-app",
    "image": "${backend_app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${backend_app_port},
        "hostPort": ${backend_app_port}
      }
    ]
  }
]