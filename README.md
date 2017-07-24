# tf-aws-ebs-lambda-snapshot

Scheduled Snapshots for EBS Volumes

## Usage

```
module "jenkins_ebs_backup" {
  source                        = "../modules/tf-aws-lambda-ebs-snapshot"
  volume_id                     = "${aws_ebs_volume.jenkins.id}"
  envname                       = "${var.envname}"
  service                       = "jenkins"
  lambda_function_name          = "${var.envname}-jenkins-ebs-weekly-backup"
  cloudwatch_event_rule_name    = "${var.envname}-jenkins-ebs-weekly-backup"
  lambda_version                = "v0.1"
  cron_schedule                 = "cron(0 2 ? * SUN *)"
  tag_value                     = "${var.envname}-jenkins-ebs-weekly"
  snapshots_to_keep             = 4
  lambda_logs_retention_in_days = 30
}

```

## Variables

Variables marked with an * are mandatory, the others have sane defaults and can be omitted.

* `envname`\* - Environment name (eg,test, stage or prod)
* `service`\* - Service name
* `cloudwatch_event_rule_name`\* - Name for Cloudwatch Rule - keep this unique as TF will happily reuse an exising one if it has the same name
* `lambda_function_name`\* - Lambda function name
* `lambda_version`\* - Version of lambda function
* `volume_id`\* - ID of the volume to snapshot
* `cron_schedule` - [Schedule expression](http://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)
* `snapshots_to_keep` - How many snapshots to keep
* `tag_name` - Tag name for snapshots. Used to filter them as well
* `tag_value` - Tag value for snapshots. Used to filter them as well
* `aws_region` - AWS region
* `lambda_logs_retention_in_days` - How long to keep lambda logs for
