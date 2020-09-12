locals {
  s3ResizeTriggerLambda = {
    name = "s3-on-original-added-trigger-resize-lambda"
    handler = "index.handler"
  }
}

//resource "aws_cloudwatch_log_group" "s3-on-original-added-trigger-resize-lambda" {
//  name              = "/aws/lambda/${local.uploadLambda.name}"
//  retention_in_days = 14
//}

resource "aws_lambda_function" "s3ResizeTriggerLambda" {

  filename = "../${local.s3ResizeTriggerLambda.name}/dist/${local.s3ResizeTriggerLambda.name}.zip"
  function_name = local.s3ResizeTriggerLambda.name
  role = aws_iam_role.iam_for_lambda.arn
  handler = local.s3ResizeTriggerLambda.handler

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("../${local.s3ResizeTriggerLambda.name}/dist/${local.s3ResizeTriggerLambda.name}.zip")

  timeout = 600
  runtime = var.runtime

  environment {
    variables = {
      ALLOWED_DIMENSIONS = var.ALLOWED_DIMENSIONS
      RESIZE_LAMBDA_API_GATEWAY_URL = aws_api_gateway_deployment.deployment.invoke_url
      IMAGE_PATH = aws_api_gateway_resource.MyDemoResource.path
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3ResizeTriggerLambda.arn
  principal = "s3.amazonaws.com"
  source_arn = module.cdn.s3_bucket_arn
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.cdn.s3_bucket

  dynamic lambda_function {
    for_each = var.imageTypes
    content {
    lambda_function_arn = aws_lambda_function.s3ResizeTriggerLambda.arn
    events = [
      "s3:ObjectCreated:*"
    ]
    filter_suffix = lambda_function.value
   }
  }

  depends_on = [
    aws_lambda_permission.allow_bucket
  ]
}