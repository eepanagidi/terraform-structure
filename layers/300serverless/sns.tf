resource "aws_sns_topic" "sns_topic_example" {
    name = "sns-topic-name"
    display_name = "APP-Notification-${var.environment}"
    tags = merge(
        local.tags,
        {
            Name = "sns-topic-name"
        }
    )
}

resource "aws_sns_topic_subscription" "sns_topic_example_subscription" {
    topic_arn = aws_sns_topic.sns_topic_example.arn
    protocol = "email"
    endpoint = var.sns_email
}