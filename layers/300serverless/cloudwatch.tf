resource "aws_cloudwatch_log_group" "log_group_example" {
    name = "e.g needs to match resource's name precisely /aws-lambda/lambda-job"
    retention_in_days = var.environment == "production" ? 7 : 2
    tags = local.tags
}

# metric filter example
resource "aws_cloudwatch_log_metric_filter" "metric_filter_example" {
    name = "log_group_example_metric_filter"
    pattern = "[timestamp=*Z, loglevel=\"ERROR\" || loglevel=\"WARN\" ||loglevel=\"FATAL\" || loglevel=\"EXCEPTION\"]"
    log_group_name = aws_cloudwatch_log_group.log_group_example.name

    metric_transformation {
        name = "example_name"
        namespace = "Project"
        value = "1"
    }
}

# cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "alarm_example" {
    alarm_name = "alarm-name-${var.environment}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    period = 60
    metric_name = aws_cloudwatch_log_metric_filter.metric_filter_example.metric_transformation[0].name
    namespace = aws_cloudwatch_log_metric_filter.metric_filter_example.metric_transformation[0].namespace
    threshold = 0
    statistic = "Average"
    alarm_description = "Description"
    alarm_actions = [aws_sns_topic.sns_topic_example.arn]
    tags = local.tags
}

resource "aws_cloudwatch_event_rule" "event_failure_rule" {
    name = "failure-rule"
    description = "Triggers in case of failure"
    tags = local.tags
    event_pattern = jsoncode({
        "source": ["aws.glue"],
        "detail-type": ["Glue Crawler State Change"],
        "detail": {
            "state": ["Failed"],
            "crawlerName": [
                ... arns of crawlers
            ]
        }
    })
}

resource "aws_cloudwatch_event_target" "failure_target" {
    rule = aws_cloudwatch_event_rule.event_failure_rule.name
    arn = aws_sns_topic.sns_topic_example.arn

    input_transformer {
        input_paths = {
            "crawlerName" = "${.detail.crawlerName}"
            "state" = "${.detail.state}"
            "errorMessage" = "${.detail.errorMessage}"
            "timestamp" = "${.time}"
        }

        input_template = <<EOT
{
    "Crawler Name": <crawlerName>,
    "Status": <state>,
    "Error": <errorMessage>,
    "Timestamp": <timestamp>
}
EOT
    }
}