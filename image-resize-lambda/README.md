# Resize Lambda

# Description
Using the [sharp](https://www.npmjs.com/package/sharp) npm library resizes an uploaded s3 file.

## How it works:
This lambda depends to be deployed on an ApiGateway resource.
It reads the queryStringParameters.key to figure out the resize of the image.
Using sharp, creates a new object and then puts it into the S3 bucket.

Considering S3 bucket is `cdn.yourwebsite.com`

1. you unload a file `/someFolder/fileName.png`
1. you make a request to the APIGateway 
    - apigateway.com/production?key=500x200/someFolder/fileName.png
1. A new file is created s3 bucket `cdn.yourwebsite.com/500x200/someFolder/yourImage.png`

### Example:
```
event.queryStringParameters.key = "key=500x200/someFolder/fileName.png"
ALLOWED_DIMENSIONS = "500x200,100x100"
``` 
Will result in the image in the S3 bucket:
```
cdn.yourwebsite.com/500x200/someFolder/yourImage.png
``` 