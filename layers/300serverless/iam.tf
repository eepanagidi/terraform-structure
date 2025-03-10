#IAM role
resource "aws_iam_role" "role_example" {
    name = "role-name-${var.environment}"
    assume_role_policy = data.aws_iam_policy_document.document_name.json
    tags = merge(
        local.tags,
        {
            Name = "role-name-${var.environment}"
        }
    )
}

# Assume role policy for IAM role
data "aws_iam_policy_document" "document_name" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["service identifier e.g glue.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}

# policy document for IAM role
data "aws_iam_policy_document" "access_document" {
    statement {
        sid = "Service e.g DynamoDB"
        effect = "Allow"
        actions = [
            "dynamodb:GetItem",
            "dynamodb:Scan"
        ]
        resources = [
            "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/tableName",
            "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/tableName1"
        ]
    }

    statement {
        sid = "S3"
        effect = "Allow"
        actions = [
            "s3:PutObject",
            "s3:GetObject"
        ]
        resources = [
            aws_s3_bucket.bucket_name.id #this would normally come from the remote layer
        ]
    }

    statement {
        sid = "Cloudwatch"
        effect = "Allow"
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            logs:PutLogEvents"
        ]

# always put the log group arn in this format and now in aws_cloudwatch_log_group.log_group_name.name
        resources = [
            "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:log_group_name_matching_resource_name_precisely"
        ]
    }
}

# Add policy to IAM role
resource "aws_iam_role_policy" "role_example_policy" {
    name = "role_example_policy"
    role = aws_iam_role.role_example.name
    police = data.aws_iam_policy_document.access_document.json
}

# SNS policy
resource "aws_sns_topic_policy" "failure_sns_policy" {
    arn = aws_sns_topic.sns_topic_example.arn
    policy = data.aws_iam_policy_document.failure_sns_policy_document.json
}

data "aws_iam_policy_document" "failure_sns_policy_document" {
    statement {
        sid = "Allow_EBR_Publish_Alarms"
        effect = "Allow"
        resources = [aws_sns_topic.sns_topic_example.arn]
        actions = ["sns:Publish"]
        principals {
            type = "Service"
            identifiers = ["events.amazonaws.com"]
        }
    }

    statement {
        sid = "Allow_CLOUDWATCH_Publish_Alarms"
        effect = "Allow"
        resources = [aws_sns_topic.sns_topic_example.arn]
        actions = ["sns:Publish"]
        principals {
            type = "Service"
            identifiers = ["cloudwatch.amazonaws.com"]
        }
        condition {
            test = "ArnLike"
            variable = "aws:SourceArn"
            values = [
                "arn"aws"cloudwatch:${var.aws_region}:${var.aws_account_id}:alarm:*"
            ]
        }
    }
}