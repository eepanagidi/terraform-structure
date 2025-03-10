/**
 * # 100data
 */
provider "aws" {
    region = var.aws_region
    allowed_account_ids = [var.aws_account_id]

    default_tags {
        tags = local.tags
    }
} 

locals {
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

# TF dummy triger
resource "terraform_data" "dummy_trigger" {
    triggers_replace = [
        timestamp()
    ]
}

data "archive_file" "file_to_be_archived" {
    type = "zip"
    output_path = "${path.module}/file_to_be_archived.zip"

    source {
        content = data.local_file.local_file_name.content
        filename = "file_to_be_archived"
    }
}

data "local_file" "local_file_name" {
    filename = "${path.root}/s3_scripts/test.py"
    depends_on = [
        terraform_data.dummy_trigger
    ]
}