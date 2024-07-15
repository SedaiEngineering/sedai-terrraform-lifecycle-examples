import json

def lambda_handler(event, context):
    # The event parameter contains the input data to the function
    # The context parameter contains runtime information

    # Create a response
    response = {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Hello, World!"
        })
    }
    
    return response
