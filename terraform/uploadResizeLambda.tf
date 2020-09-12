locals {
  uploadLambda = {
    name = "image-resize-lambda"
    handler = "index.handler"
  }
}

resource "aws_lambda_function" "uploadLambda" {

  filename = "../${local.uploadLambda.name}/dist/${local.uploadLambda.name}.zip"
  function_name = local.uploadLambda.name
  role = aws_iam_role.uploadResizeLambda.arn
  handler = local.uploadLambda.handler

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("../${local.uploadLambda.name}/dist/${local.uploadLambda.name}.zip")

  runtime = var.runtime
  timeout = 200

  environment {
    variables = {
      BUCKET = module.cdn.s3_bucket
      URL = module.cdn.s3_bucket_domain_name
      ALLOWED_DIMENSIONS = var.ALLOWED_DIMENSIONS
    }
  }
}

