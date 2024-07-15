# Manage resource lifecycle
Lifecycle arguments help control the flow of your Terraform operations by creating custom rules for resource creation and destruction. Instead of Terraform managing operations in the built-in dependency graph, lifecycle arguments help minimize potential downtime based on your resource needs as well as protect specific resources from changing or impacting infrastructure.
## Ignore changes
For changes outside the Terraform workflow that should not impact Terraform operations, we use the ignore_changes argument. Here are some expamles we can use to ignore the changes made by Sedai.

### lifecycle ignore_changes are applied to:
### EC2
* instance_type

### EBS
* iops
* type
* throughput
* size

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
* capacity_provider

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

