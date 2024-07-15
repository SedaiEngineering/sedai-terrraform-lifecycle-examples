
resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 100   # Size in GB
  type              = "io1" # Volume type
  iops              = 1000  # IOPS (Only for io1 and io2 types)

  tags = {
    Name = "example-volume"
  }

  lifecycle {
    ignore_changes = [
      iops,
      type
    ]
  }
}
