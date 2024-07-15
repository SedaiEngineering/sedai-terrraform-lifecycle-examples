## lifecycle ignore_changes apre applied to 
### EC2
* instance_type

### EBS
* iops
* type

### ECS
####  aws_ecs_service
* desired_count
* capacity_provider_strategy
* enable_ecs_managed_tags
* enable_execute_command
* scheduling_strategy
#### aws_ecs_task_definition
*  cpu,
*  memory,
*  container_definitions
#### aws_ecs_cluster_capacity_providers
* default_capacity_provider_strategy
* CapacityProviders

### lambda
#### aws_lambda_function
* memory_size
* reserved_concurrent_executions
####   aws_lambda_provisioned_concurrency_config
* provisioned_concurrent_executions

### S3
#### aws_s3_bucket_lifecycle_configuration
* rule
#### aws_s3_bucket_intelligent_tiering_configuration
* tiering

### S3 lifecycle rule changes
Currently, changes to the lifecycle_rule configuration of existing resources cannot be automatically detected by Terraform. To manage changes of Lifecycle rules to an S3 bucket, use the aws_s3_bucket_lifecycle_configuration resource instead. If you use lifecycle_rule on an aws_s3_bucket, Terraform will assume management over the full set of Lifecycle rules for the S3 bucket, treating additional Lifecycle rules as drift. For this reason, lifecycle_rule cannot be mixed with the external aws_s3_bucket_lifecycle_configuration resource for a given S3 bucket. So if you don't have lifecycle_rule  configured in code there is no need to make any changes.

### Ignoring Changes to Desired Count ECS
You can utilize the generic Terraform resource lifecycle configuration block with ignore_changes to create an ECS service with an initial count of running instances, then ignore any changes to that count caused externally (e.g., Application Autoscaling).

