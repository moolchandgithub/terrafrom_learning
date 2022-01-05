output "bucketlist" {
  value = ["${aws_s3_bucket.bucketC.*.bucket}"]
}