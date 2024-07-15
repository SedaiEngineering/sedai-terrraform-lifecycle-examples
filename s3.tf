resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-bucket-name"
  acl    = "private"

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    ignore_changes = [
      expiration,
      transition,
    ]
  }
}
