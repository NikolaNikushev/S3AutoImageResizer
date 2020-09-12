# S3 trigger lambda

## Description
This is a lambda that expects to have a trigger of putObject on S3 bucket.
It's used in combination with the deployed [image-resize-lambda project](../image-resize-lambda/README.md) in the previous folder 
to trigger create of all needed sizes for an image when uploaded to an S3 bucket.

## How it works:
It retrieves the s3 file name from the event `event.Records[0].s3.object.key` and using that name makes multiple HTTP requests 
toward the `RESIZE_LAMBDA_API_GATEWAY_URL` configured as an environment variable. 
Based on the `ALLOWED_DIMENSIONS` it will trigger an API gateway request to load a specific image file.

### Example:
```
RESIZE_LAMBDA_API_GATEWAY_URL = "http://apigatewayUrl.com"
ALLOWED_DIMENSIONS = "500x200,100x100"
event.Records[0].s3.object.key = "someFolder/yourImage.png"
``` 
Will result in the following 2 requests:
```
HTTP GET: http://apigatewayUrl.com/500x200/someFolder/yourImage.png
HTTP GET: http://apigatewayUrl.com/100x100/someFolder/yourImage.png
``` 

The `RESIZE_LAMBDA_API_GATEWAY_URL` is deployed using the [image-resize-lambda project](../image-resize-lambda/README.md) in the previous folder.

