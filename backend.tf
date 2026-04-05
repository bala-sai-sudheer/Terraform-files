terraform {
  backend "s3" {
    bucket       = "infra.storage"
    key          = "Statefile/Terraform/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }
}

