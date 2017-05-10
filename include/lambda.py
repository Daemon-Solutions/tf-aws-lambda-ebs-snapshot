#!/usr/bin/python

import boto3
import os 
import json


aws_region = os.environ.get('AWS_DEFAULT_REGION')
client = boto3.client('ec2', region_name=aws_region)

def get_snapshots(volume_id, tag_name, tag_value):
    paginator = client.get_paginator('describe_snapshots')
    snapshots_paginate = paginator.paginate(
        Filters=[
            {
                'Name': 'status',
                'Values': ('completed',)
            },
            {
                'Name': 'volume-id',
                'Values': (volume_id,)
            },
            {
                'Name': 'tag:{}'.format(tag_name),
                'Values': (tag_value,)
            }
        ]
    )
    snapshots = snapshots_paginate.build_full_result()['Snapshots']
    #sort from newest
    snapshots.sort(key=lambda d: d['StartTime'], reverse=True)
    return snapshots

def lambda_handler(event, context):

    volume_id = event['volume_id']
    snapshots_to_keep = event['snapshots_to_keep']
    tag_name = event['tag_name']
    tag_value = event['tag_value']
            
    
    # create new snapshot
    new_snapshot = client.create_snapshot(VolumeId=volume_id)
    
    # tag snapshot
    client.create_tags(
        Resources=[
            new_snapshot['SnapshotId']
        ],
        Tags=[
            {
                'Key': tag_name,
                'Value': tag_value
            }
        ]
    )
    
    # discover snapshots
    snapshots = get_snapshots(volume_id, tag_name, tag_value)

    # delete old snapshots
    if len(snapshots) > snapshots_to_keep:
        snapshots_to_delete = snapshots[snapshots_to_keep:]
        for snapshot in snapshots_to_delete:
            snapshot_id = snapshot['SnapshotId']
            client.delete_snapshot(snapshot_id)
        

            
            
        

            