
resource "aws_api_gateway_rest_api" "visitorapi" {
  name = "visitor-tracker"
}

resource "aws_api_gateway_resource" "status" {
  parent_id   = aws_api_gateway_rest_api.visitorapi.root_resource_id
  path_part   = "status"
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_method" "getstatus" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.status.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_integration" "statusintegration" {
  resource_id             = aws_api_gateway_resource.status.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = aws_api_gateway_method.getstatus.http_method
  integration_http_method = "POST"
}

resource "aws_api_gateway_resource" "visitor" {
  parent_id   = aws_api_gateway_rest_api.visitorapi.root_resource_id
  path_part   = "visitor"
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_method" "getvisitor" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.visitor.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_integration" "visitorintegration" {
  resource_id             = aws_api_gateway_resource.visitor.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = "GET"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "patchvisitor" {
  authorization = "NONE"
  http_method   = "PATCH"
  resource_id   = aws_api_gateway_resource.visitor.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}
resource "aws_api_gateway_integration" "patchvisitorintegration" {
  resource_id             = aws_api_gateway_resource.visitor.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = "PATCH"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "deletevisitor" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.visitor.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_integration" "deletevisitorintegration" {
  resource_id             = aws_api_gateway_resource.visitor.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = "DELETE"
  integration_http_method = "POST"
}


resource "aws_api_gateway_method" "postvisitor" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.visitor.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}
resource "aws_api_gateway_integration" "postvisitorintegration" {
  resource_id             = aws_api_gateway_resource.visitor.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = "POST"
  integration_http_method = "POST"
}

resource "aws_api_gateway_method" "corsoptions" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.visitor.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_integration" "corsoptionintegration" {
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  resource_id             = aws_api_gateway_resource.visitor.id
  http_method             = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  integration_http_method = "POST"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
  resource_id = aws_api_gateway_resource.visitor.id
  http_method = aws_api_gateway_method.postvisitor.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }

  response_models = {
    "application/json" = "Empty" # or reference a model if you've defined one
  }
}

resource "aws_api_gateway_integration_response" "postcorsintegrationresponse" {
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
  resource_id = aws_api_gateway_resource.visitor.id
  http_method = aws_api_gateway_method.postvisitor.http_method
  status_code = "200"
}

resource "aws_api_gateway_resource" "visitors" {
  parent_id   = aws_api_gateway_rest_api.visitorapi.root_resource_id
  path_part   = "visitors"
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
}

resource "aws_api_gateway_method" "getvisitors" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.visitors.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
}
resource "aws_api_gateway_integration" "visitorsintegration" {
  resource_id             = aws_api_gateway_resource.visitors.id
  rest_api_id             = aws_api_gateway_rest_api.visitorapi.id
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.visitor-counter.invoke_arn
  http_method             = "GET"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "apideployment" {
  rest_api_id = aws_api_gateway_rest_api.visitorapi.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.status.id,
      aws_api_gateway_method.getstatus.id,
      aws_api_gateway_integration.statusintegration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  depends_on    = [aws_cloudwatch_log_group.visitorlogs]
  deployment_id = aws_api_gateway_deployment.apideployment.id
  rest_api_id   = aws_api_gateway_rest_api.visitorapi.id
  stage_name    = "production"
}

