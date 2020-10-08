resource "aws_s3_bucket" "deploy_bucket" {
  acl = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT","POST"]
    allowed_origins = ["*"]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }

  policy = <<EOF
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
  EOF

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_cloudfront_distribution" "cf_distrib" {
  default_cache_behavior {
    allowed_methods = ["GET", "PATCH", "PUT", "HEAD", "POST", "DELETE", "OPTIONS"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = aws_s3_bucket.deploy_bucket.bucket_domain_name
    viewer_protocol_policy = "allow-all"
  }

  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = "true"

  ordered_cache_behavior {
    allowed_methods = ["GET", "OPTIONS", "HEAD"]
    cached_methods  = ["OPTIONS", "GET", "HEAD"]
    compress        = "true"
    default_ttl     = "86400"

    forwarded_values {
      cookies {
        forward = "none"
      }

      headers      = ["Origin"]
      query_string = "false"
    }

    max_ttl                = "31536000"
    min_ttl                = "0"
    path_pattern           = "/content/immutable/*"
    smooth_streaming       = "false"
    target_origin_id       = aws_s3_bucket.deploy_bucket.bucket_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods = ["HEAD", "OPTIONS", "GET"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "3600"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "86400"
    min_ttl                = "0"
    path_pattern           = "/content/*"
    smooth_streaming       = "false"
    target_origin_id       = aws_s3_bucket.deploy_bucket.bucket_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

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

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = "true"
    minimum_protocol_version       = "TLSv1"
  }
}


output "bucket" {
  value = aws_s3_bucket.deploy_bucket.bucket
}

output "url" {
  value = aws_cloudfront_distribution.cf_distrib.domain_name
}

output "cf_id" {
  value = aws_cloudfront_distribution.cf_distrib.id
}
