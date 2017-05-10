resource "aws_cloudwatch_event_rule" "volume_backup" {
  name                = "volume_backup"
  description         = "Trigger for lambda volume backup"
  schedule_expression = "${var.cron_schedule}"
}

resource "aws_cloudwatch_event_target" "volume_backup" {
  rule = "${aws_cloudwatch_event_rule.volume_backup.name}"
  arn  = "${aws_lambda_function.volume_backup.arn}"

  input = <<EOF
{
  "volume_id": "${var.volume_id}",
  "snapshots_to_keep": "${var.snapshots_to_keep}",
  "tag_name": "${var.tag_name}",
  "tag_value": "${var.tag_value}"
}
EOF
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_backup" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.volume_backup.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.volume_backup.arn}"
}
