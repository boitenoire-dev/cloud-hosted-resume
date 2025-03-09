resource "aws_dynamodb_table" "visitor-tracker" {
  name         = "visitor-tracker"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "visitorid"

  attribute {
    name = "visitorid"
    type = "S"
  }

  tags = {
    Project = "Cloud Resume Project"
  }
}



