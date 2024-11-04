resource "aws_kinesis_stream" "blackstone-kinesis" {
  name             = "blackstone-kinesis-${var.environment}"
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = var.environment
  }
}
