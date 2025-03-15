data "archive_file" "visitor-counter-lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "visitorcounter2.zip"
}
