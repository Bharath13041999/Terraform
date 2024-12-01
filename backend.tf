terraform {
  backend "s3" {
    bucket = "test-tfstate-bucket"
    key = "main"
    region = "us-east-1"
    dynamodb_table = "test-dynamodb-table"
  }
}