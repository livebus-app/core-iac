resource "aws_dynamodb_table" "bucket-digest-dynamodb" {
  name           = "bucket_digest"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_s3_bucket" "livebus-samples" {
  bucket = "livebus-samples"
  
  tags = {
    Name = "livebus-samples"
  }
}

resource "aws_s3_object" "livebus-samples" {
  bucket = aws_s3_bucket.livebus-samples.id
  key    = "sample.jpeg"
  source = "./.samples/sample.jpeg"

  content_type = "image/jpeg"
}