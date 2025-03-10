/**
 * # 300serverless
 */
provider "aws" {
    region = var.aws_region
    allowed_account_ids = [var.aws_account_id]

    default_tags {
        tags = local.tags
    }
} 

locals {
    test_remote_state_output = data.terraform_remote_state.test_remote_state.outputs.output_name
    tags = {
        Environment = var.environment
        Layer = var.Layer
        Terraform = "True"
        Project = title(local.project_name)
        Repo = "repo_url"
        Team = "Team"
        Owner = "Owner"
        BusinessStream = "Stream"
        Brand = "CompanyName"
    }

    project_name = "Hera"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "test_remote_state" {
    backend = "s3"
    config = {
        bucket = "${data.aws_caller_identity.current.account_id}-tf-state"
        key = "env:/{terraform.workspace}/test_remote_state/terraform.100data.tfstate"
        regiom = var.aws_region
    }
}


