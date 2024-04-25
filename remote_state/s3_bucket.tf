# create s3 bucket for terraform remote state
resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.project_name}-tf-remote-state"
}

# attach bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# make s3 bucket private
resource "aws_s3_bucket_acl" "remote_state" {
  depends_on = [aws_s3_bucket_ownership_controls.remote_state]

  bucket = aws_s3_bucket.remote_state.id
  acl    = "private"
}