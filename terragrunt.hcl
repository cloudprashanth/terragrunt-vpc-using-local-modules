remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt = true
    bucket  = "terraform-files-9055"
    key     = "${path_relative_to_include()}/terragrunt-vpc-project.tfstate"
    region  = "us-east-1"
    profile = "default"

  }
}