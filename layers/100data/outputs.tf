output "s3_bucket" {
    description = "The S3 bucket id"
    value = aws_s3_bucket.bucket_name.id
}