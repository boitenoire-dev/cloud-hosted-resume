resource "aws_s3_bucket" "lambda-visitor-counter-resources" {
  bucket = "lambda-visitor-counter-resources"
  tags = {
    Name    = "lambda-visitor-counter-resources"
    Project = "Cloud Resume Project"
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  versioning_configuration {
    status = "Enabled"
  }
}





resource "aws_s3_object" "lambda-visitor-counter-code" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  key    = "visitorcounter2.zip"
  source = data.archive_file.visitor-counter-lambda.output_path
  etag   = filemd5(data.archive_file.visitor-counter-lambda.output_path)
}

resource "aws_s3_object" "resume" {
  bucket       = aws_s3_bucket.lambda-visitor-counter-resources.id
  key          = "resume.html"
  source       = "resume.html"
  etag         = filemd5(data.archive_file.visitor-counter-lambda.output_path)
  acl          = "public-read"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "visitorcounterconfig" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  index_document {
    suffix = "resume.html"
  }
}

resource "aws_s3_bucket_public_access_block" "openvisitorbucket" {
  bucket                  = var.bucket_name
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.openvisitorbucket]
}

resource "aws_s3_bucket_policy" "visitorbucketpolicy" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  policy = data.aws_iam_policy_document.visitorbucketpolicy.json
}

data "aws_iam_policy_document" "visitorbucketpolicy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::lambda-visitor-counter-resources",
      "arn:aws:s3:::lambda-visitor-counter-resources/*"
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

variable "bucket_name" {
  type    = string
  default = "lambda-visitor-counter-resources"
}
