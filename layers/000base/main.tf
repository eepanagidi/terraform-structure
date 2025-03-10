/**
 * # 000base
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
