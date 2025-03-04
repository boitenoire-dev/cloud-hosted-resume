data "archive_file" "visitor-counter-lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "visitorcounter2.zip"
}

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

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "visitor-counter" {
  # Use S3 as the source for the Lambda code
  function_name = "visitor-counter"
  s3_bucket     = aws_s3_bucket.lambda-visitor-counter-resources.bucket
  s3_key        = "visitorcounter2.zip"


  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.visitor-counter-lambda.output_base64sha256
}
