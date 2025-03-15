


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

data "aws_iam_policy_document" "cw_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "iam_for_cloudwatch" {
  name               = "iam_for_cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.cw_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cloudwatching_lambda_policy" {
  role       = aws_iam_role.iam_for_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  role       = aws_iam_role.iam_for_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_lambda_function" "visitor-counter" {
  # Use S3 as the source for the Lambda code
  function_name = "visitor-counter"
  s3_bucket     = aws_s3_bucket.lambda-visitor-counter-resources.bucket
  s3_key        = "visitorcounter2.zip"


  role             = aws_iam_role.iam_for_cloudwatch.arn
  runtime          = "python3.9"
  handler          = "lambda.lambda_handler"
  source_code_hash = data.archive_file.visitor-counter-lambda.output_base64sha256
}

resource "aws_lambda_permission" "visitorslambdapermission" {
  statement_id  = "AllowVisitorsAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor-counter.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.visitorapi.execution_arn}/*"
}

output "cw_log_group_arn" {
  value = aws_iam_role.iam_for_cloudwatch.arn
}
