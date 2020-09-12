# S3 Auto image Resizer

## Description
Using terraform and Lambda this projects deploys a CloudFront-S3 image CDN for you.  
1. Creates a S3 bucket to use as your CDN
1. Makes that S3 bucket a static website
1. Uploads 2 lambdas
    - One that will be used to resize images
    - One that will trigger creating of all sizes
1. Creates an S3 trigger to the 2-nd lambda to invoke when ever a new file is uploaded in the CDN
    - This allows automatic re-size of images
    - Uses the ALLOWED_DIMENSIONS to trigger all the needed sizes
1. Creates a cloudfront distribution that directs traffic to your new CDN

## How to use
- install [docker](https://www.docker.com/)
- install [terraform](https://www.terraform.io/)
- create a file `terraform.tfvars` based on [terraform/terraform.tfvars.example](./terraform/terraform.tfvars.example) in [terraform/](./terraform/) folder.
- You can provide variables based on [terraform-variables](./terraform/terraform-variables.tf)
- run `make`
- After ~5 minutes all deployments will be configured.
- After ~30 minutes you can access your cdn, as it requires that a CloudFront distribution is created.
- Now you can access your cdn, example: https://cdn.yourwebsite.com
