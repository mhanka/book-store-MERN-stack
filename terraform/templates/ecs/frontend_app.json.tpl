[
  {
    "name": "frontend-app",
    "image": "${frontend_app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${frontend_app_port},
        "hostPort": ${frontend_app_port}
      }
    ]
  }
]