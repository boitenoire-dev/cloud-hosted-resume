resource "aws_s3_bucket" "lambda-visitor-counter-resources" {
  bucket = "lambda-visitor-counter-resources"
  tags = {
    Name    = "lambda-visitor-counter-resources"
    Project = "Cloud Resume Project"
  }

}

resource "aws_s3_object" "lambda-visitor-counter-code" {
  bucket = aws_s3_bucket.lambda-visitor-counter-resources.id
  key    = "visitorcounter2.zip"
  source = data.archive_file.visitor-counter-lambda.output_path
  etag   = filemd5(data.archive_file.visitor-counter-lambda.output_path)
}
