variable "aws_account_id" {
    description = "The id of the AWS account to apply changes to"
    type = string
}

variable "aws_region" {
    description = "Aws region in which to create the state resources"
    type = string
}

variable "environment" {
    description = "Application environment"
    type = string
}

variable "layer" {
    description = "The name of the layer, used in local.tags"
    type = string
}

variable "sns_email" {
    description = "The email used by SNS to notify in case of failures/errors"
    type = string
}