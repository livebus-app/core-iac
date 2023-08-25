resource "aws_kinesis_stream" "lbl-dynamodb-insertion-stream" {
  name = "lbl-dynamodb-insertion-stream"
  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}
