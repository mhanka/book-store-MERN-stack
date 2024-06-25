[
  {
    "name": "backend-app",
    "image": "${backend_app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "environment": [
       {
         "name": "MONGODBURL",
         "value": "${mongodb_url}"
       }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/backend-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${backend_app_port},
        "hostPort": ${backend_app_port}
      }
    ]
  }
]