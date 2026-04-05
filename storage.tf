resource "aws_s3_bucket" "s3" {
  bucket = "sudheer.s3.bucket"
}

resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {

    status = "Enabled"
  }
}


