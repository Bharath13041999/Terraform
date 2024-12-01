terraform {
  backend "s3" {
    bucket = "test-tfstate-bucket"
    hash_key = "LockID"
    region = "us-east-1"
    dynamodb_table = "test-dynamodb-table"
  }
}