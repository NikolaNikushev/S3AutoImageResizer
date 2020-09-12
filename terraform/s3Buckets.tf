module "cdn" {
  source = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=master"
  namespace = var.cdn.namespace
  stage = "production"
  name = var.buckets.cdnBucket.name
  aliases = var.cdn.aliases
  parent_zone_name = var.route53.domainName
  acm_certificate_arn = var.amc_certificate_arn
  logging_enabled = false

  // bucket cors
  cors_allowed_headers = [
    "*"]
  cors_allowed_methods = [
    "PUT",
    "POST"]
  cors_allowed_origins = [
    "*"]
  cors_expose_headers = [
    "ETag"]
  cors_max_age_seconds = 3000

  website_enabled = true

  index_document = "index.html"
  error_document = "error.html"
}