resource "aws_ecs_cluster" "example" {
  name = "example-cluster"

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
        "container-cpuSoftLimit"    = "512",
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

  # network_configuration {
  #   subnets         = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"] # replace with your subnet IDs
  #   security_groups = ["sg-xxxxxxxx"]                        # replace with your security group ID
  # }

  # load_balancer {
  #   target_group_arn = "arn:aws:elasticloadbalancing:region:account-id:targetgroup/target-group-name/xxxxxxxxxxxxx" # replace with your target group ARN
  #   container_name   = "example-container"
  #   container_port   = 80
  # }

  lifecycle {
    ignore_changes = [
      desired_count,
      capacity_provider_strategy,
    ]
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
  lifecycle {
    ignore_changes = [
      default_capacity_provider_strategy,
      capacity_providers
    ]
  }
}

resource "aws_appautoscaling_target" "example" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.example.name}/${aws_ecs_service.example.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscaling_role.arn

  lifecycle {
    ignore_changes = [
      max_capacity,
      min_capacity
    ]
  }
}

resource "aws_appautoscaling_policy" "example" {
  name               = "ecs-autoscaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.example.resource_id
  scalable_dimension = aws_appautoscaling_target.example.scalable_dimension
  service_namespace  = aws_appautoscaling_target.example.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }

  lifecycle {
    ignore_changes = [
      target_tracking_scaling_policy_configuration[0].predefined_metric_specification,
      target_tracking_scaling_policy_configuration[0].target_value
    ]
  }
}

