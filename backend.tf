terraform {
  backend "s3" {
    bucket         = "myorg-terraform-states-main-files-123"
    key            = "prod/terraform.tfstate" # Path within the bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # Optional: For state locking
    encrypt        = true              # Optional: Enables encryption at rest (AES-256)
  }
}
