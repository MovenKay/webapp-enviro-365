terraform {
  backend "s3" {
    bucket = "terra-state-enviro365"
    dynamodb_table = "enviro365table"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
