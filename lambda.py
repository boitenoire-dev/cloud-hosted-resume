import json
import boto3
from decimal import Decimal

# Use boto3.resource to create the DynamoDB resource
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("visitor-count-table")


def lambda_handler(event, context):
    print(event)
    statusCode = 200
    headers = {"Content-Type": "application/json"}

    try:
        routeKey = event.get("routeKey")
        if routeKey == "DELETE /items/{visitor-id}":
            visitor_id = event["pathParameters"]["visitor-id"]
            table.delete_item(Key={"visitor-id": visitor_id})
            body = {"message": "Item deleted"}

        elif routeKey == "GET /items/{visitor-id}":
            visitor_id = event["pathParameters"]["visitor-id"]
            response = table.get_item(Key={"visitor-id": visitor_id})
            item = response.get("Item")
            if item:
                body = [
                    {"visitor-id": item.get("visitor-id"), "visits": item.get("visits")}
                ]
            else:
                statusCode = 404
                body = {"message": "Item not found"}

        elif routeKey == "GET /items":
            response = table.scan()
            items = response.get("Items", [])
            print("ITEMS------")
            print(items)
            body = []
            for item in items:
                response_item = {
                    "visitor-id": item.get("visitor-id"),
                    "visits": item.get("visits"),
                }
                body.append(response_item)

        elif routeKey == "PUT /items":
            requestJSON = json.loads(event["body"])
            visitor_id = requestJSON.get("visitor-id")
            visits = requestJSON.get("visits")
            table.put_item(Item={"visitor-id": visitor_id, "visits": visits})
            body = {"message": "Put item " + visitor_id}

        else:
            statusCode = 400
            body = {"message": "Unsupported route " + str(routeKey)}

    except Exception as e:
        statusCode = 500
        body = {"message": "Error processing request", "error": str(e)}

    response = {"statusCode": statusCode, "headers": headers, "body": json.dumps(body)}

    return response
