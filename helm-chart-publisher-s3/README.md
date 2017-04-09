# helm-chart-publisher-s3

A Helm Chart intended for use in Landscape. Pass the following environment variables when running `landscaper apply`
 - AWS_ACCESSKEY
 - AWS_SECRETKEY
 - AWS_REGION
 - S3_BUCKET

Example:
```
AWS_ACCESSKEY=01234abc AWS_SECRETKEY=98765432 AWS_REGION=us-west-2 S3_BUCKET=mybucket landscaper apply --dir landscape/helm-chart-publisher/helm-chart-publisher/ --namespace=helm-chart-publisher
```
