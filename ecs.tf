resource "aws_ecs_cluster" "example" {
  name = "example-cluster"

  lifecycle {
    ignore_changes = [
      capacity_providers,
      default_capacity_provider_strategy
    ]
  }
}

resource "aws_ecs_task_definition" "example" {
  family                   = "example-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "example-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      dockerLabels = {
        "container-memorySoftLimit" = "512MiB",
        "container-memoryHardLimit" = "1GiB",
        "container-cpuSoftLimit" = "512",
      }
    }
  ])

  lifecycle {
    ignore_changes = [
      cpu,
      memory,
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "example" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1

  launch_type = "EC2"

  network_configuration {
    subnets         = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]  # replace with your subnet IDs
    security_groups = ["sg-xxxxxxxx"]                         # replace with your security group ID
  }

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/target-group-name/xxxxxxxxxxxxx"  # replace with your target group ARN
    container_name   = "example-container"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      capacity_provider_strategy,
      enable_ecs_managed_tags,
      enable_execute_command,
      scheduling_strategy,
    ]
  }
}
