terraform {
    required_version = "1.10.3"

    backend "s3" {
        key = "<project>/terraform.000base.tfstate"
    }

    required_providers {
        aws = {
            source = hashicorp/aws
            version = "~> 5.0"
        }
    }
}