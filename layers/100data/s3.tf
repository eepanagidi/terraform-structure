resource "aws_s3_bucket" "bucket_name" {
    bucket = "${var.aws_account_id}-bucket-name"
    tags = merge(
        local.tags,
        {
            Name = "${var.aws_account_id}-bucket-name",
            DifferentTag = "value-of-tag"
        }
    )
}

# Encrypt bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
    bucket = aws_s3_bucket.bucket_name.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Block public access for bucket
resource "aws_s3_bucket_public_access_block" "bucket_block" {
    bucket = aws_s3_bucket.bucket_name.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# Versioning on S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.bucket_name.id
    versioning_configuration {
        status = "Enabled"
    }
}

# Lifecycle policy example on S3 bucket
resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle_policy" {
    bucket = aws_s3_bucket.bucket_name.id

    rule {
        id = "FullDelete"

        noncurrent_version_expiration {
            noncurrent_days = 1
        }

        abort_incomplete_multipart_upload {
            days_after_initiation = 1
        }

        expiration {
            days = 7
        }

        status = "Enabled"
    }
}

# File upload S3
resource "aws_s3_object" "s3_bucket_object" {
    bucket = aws_s3_bucket.bucket_name.id
    key = "s3_scripts/test.py"
    acl = "private"
    source = "${path.root}/s3_scripts/test.py"
    source_hash = filemd5("${path.root}/s3_scripts/test.py)
}