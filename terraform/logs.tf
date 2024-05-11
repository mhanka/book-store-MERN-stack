# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "frontend_app_log_group" {
  name              = "/ecs/frontend-app"
  retention_in_days = 30

  tags = {
    Name = "frontend-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "frontend_app_log_stream" {
  name           = "frontend-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.frontend_app_log_group.name
}

resource "aws_cloudwatch_log_group" "backend_app_log_group" {
  name              = "/ecs/backend-app"
  retention_in_days = 30

  tags = {
    Name = "backend-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "backend_app_log_stream" {
  name           = "backend-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.backend_app_log_group.name
}

