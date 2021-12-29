terraform {
  backend "s3" {
    bucket         = "talent-academy-954444250632-tfstates"
    key            = "ansible-githubactions-demo/terraform.tfstates"
    dynamodb_table = "terraform-lock"
  }
}