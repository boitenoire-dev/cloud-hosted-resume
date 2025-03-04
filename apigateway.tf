resource "aws_apigatewayv2_api" "visitors" {
  name          = "visitors"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "status" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "GET /status"
}

resource "aws_apigatewayv2_route" "postvisitor" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "POST /visitor"
}

resource "aws_apigatewayv2_route" "getvisitor" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "GET /visitor"
}

resource "aws_apigatewayv2_route" "deletevisitor" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "DELETE /visitor"
}

resource "aws_apigatewayv2_route" "getvisitors" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "GET /visitors"
}

resource "aws_apigatewayv2_route" "postvisitors" {
  api_id    = aws_apigatewayv2_api.visitors.id
  route_key = "POST /visitors"
}

resource "aws_apigatewayv2_integration" "visitorslambda" {
  api_id           = aws_apigatewayv2_api.visitors.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.visitor-counter.invoke_arn
}
