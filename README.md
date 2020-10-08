# CF/S3 Nextjs deployment

## Build steps

The build scripts runs yarn build && next export, this outputs an s3 friendly folder.

## next.config.js

```trailingSlash``` is set to true, this makes sure all urls end with a /, otherwise s3/cf won't find your pages

## s3 config

both ```error document``` and ```index document``` points to index.html, could redirect to a dedicated 404 page instead but kept it simple for this POC

This policy is also very important

```JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::terraform-20201008153745286400000001/*"
        }
    ]
}
```

## Cloud front config

Origin must be configured as such otherwise things might break (index.html in subfolders)

```
origin {
    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1", "TLSv1.2"]
    }

    domain_name = aws_s3_bucket.deploy_bucket.website_endpoint
    origin_id   = aws_s3_bucket.deploy_bucket.bucket_domain_name
  }
```
