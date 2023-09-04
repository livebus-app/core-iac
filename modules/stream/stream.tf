resource "aws_kinesis_stream" "lbl_dynamodb_insertion_stream" {
  name        = "lbl-dynamodb-insertion-stream"
  shard_count = 1
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

resource "aws_dynamodb_kinesis_streaming_destination" "lbl_dynamodb_insertion_stream_destination" {
  table_name = var.dynamodb-stream-table-name
  stream_arn = aws_kinesis_stream.lbl_dynamodb_insertion_stream.arn
}
