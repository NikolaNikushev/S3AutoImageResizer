variable aws_access_key_id {
  type = string
  description = "Your access key generated for your IAM account."
  validation {
    condition     = length(var.aws_access_key_id) > 0
    error_message = "You must enter a aws_access_key_id."
  }
}

variable aws_secret_access_key {
  type = string
  description = "The associated secret access key generated for your IAM account."
  validation {
    condition     = length(var.aws_secret_access_key) > 0
    error_message = "You must enter a aws_secret_access_key."
  }
}

variable ALLOWED_DIMENSIONS {
  type = string
  default = "1080x1080,128x128,1800x1600,400x120,800x420"
  description = "List of allowed dimensions which are being used to resize your images. Input is divided WIDTHxHEIGHT. More image resizes are separated by comma example: 1080x1080,128x128."
  validation {
    condition     = length(var.ALLOWED_DIMENSIONS) > 0 && can(regex("((\\d+)x(\\d+))",var.ALLOWED_DIMENSIONS))
    error_message = "You must enter ALLOWED_DIMENSIONS in format example: 1080x1080,128x128."
  }
}

variable "amc_certificate_arn" {
  type = string
  description = "Your certificate on the Amazon certificate manager for HTTPS access to your website."
  validation {
    condition     = length(var.amc_certificate_arn) > 0 && can(regex("arn:aws:acm:(.*):(\\d+):certificate/(.*)", var.amc_certificate_arn))
    error_message = "Please enter a valid  amc_certificate_arn. Should be in the format arn:aws:acm:(region):(account_number):certificate/(certificate_arn)."
  }
}

variable cdn {
  type = object({
    namespace = string,
    aliases = list(string)
  })
  description = "Variables about your CDN. The alias are associated on your CLoudFront distribution. Namespace groups this cloudfront distribution."
  validation {
    condition     = length(var.cdn.aliases) > 0
    error_message = "Please enter cdn.aliases."
  }
  validation {
    condition     = length(var.cdn.namespace) > 0
    error_message = "Please enter cdn.namespace."
  }
}

variable "route53" {
  type = object({
    domainName = string,
  })
  description = "The route53 record of your domain. This is used to associate the route53 record for the aliases created by the CloudFront."
  validation {
    condition     = length(var.route53.domainName) > 0
    error_message = "Please enter your route53.domainName."
  }
}

variable "buckets" {
  type = object({
    cdnBucket = object({name = string}),
  })
  description = "The s3 buckets that are needed for this project. The buckets.cdnBucket creates a new bucket for your CDN where you can upload pictures."
  validation {
    condition     = length(var.buckets.cdnBucket.name) > 0
    error_message = "Please enter the s3 bucket name you would like to use for file upload."
  }
}

variable "runtime" {
  type=string
  default = "nodejs12.x"
}

variable "imageTypes" {
  type = list(string)
  description = "A list of supported image types (extensions) which will be used to listen on the S3 and forwarded to the resize lambda."
  default = [
    ".png",".PNG",
    ".jpg",".JPG",
    ".jpeg",".JPEG"
  ]
  validation {
    condition     = length(var.imageTypes) > 0
    error_message = "Please enter imageTypes. It should be an array of image extensions you wish to resize."
  }
}
