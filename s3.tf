resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-bucket-name"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }


  }

  lifecycle {
    ignore_changes = [
      rule
    ]
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "example-entire-bucket" {
  bucket = aws_s3_bucket.example_bucket.id
  name   = "EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 125
  }

  lifecycle {
    ignore_changes = [
      tiering
    ]
  }
}