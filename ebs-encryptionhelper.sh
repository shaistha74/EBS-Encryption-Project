#!/bin/bash

REGION="us-east-1"
INSTANCE_ID="i-0888aabdfc4a1d3bc"  # Replace with your EC2 Instance ID
AVAILABILITY_ZONE="us-east-1b"  # Replace with your instance's AZ

# Stop the EC2 Instance
aws ec2 stop-instances --instance-ids $INSTANCE_ID --region $REGION
echo "Stopping instance $INSTANCE_ID..."
aws ec2 wait instance-stopped --instance-ids $INSTANCE_ID --region $REGION
echo "Instance $INSTANCE_ID stopped."

# Identify unencrypted EBS volumes
echo "Identifying unencrypted EBS volumes..."
unencrypted_volumes=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$INSTANCE_ID --query "Volumes[?Encrypted==\`false\`].VolumeId" --region $REGION --output text)

for vol in $unencrypted_volumes; do
  echo "Processing volume: $vol"

  # Create Snapshot
  snapshot_id=$(aws ec2 create-snapshot --volume-id $vol --description "Snapshot of $vol for encryption" --region $REGION --query 'SnapshotId' --output text)
  echo "Snapshot created: $snapshot_id"

  # Wait for Snapshot Completion
  echo "Waiting for snapshot to complete..."
  aws ec2 wait snapshot-completed --snapshot-ids $snapshot_id --region $REGION

  # Copy Snapshot with Encryption
  encrypted_snapshot=$(aws ec2 copy-snapshot --source-region $REGION --source-snapshot-id $snapshot_id --encrypted --region $REGION --query 'SnapshotId' --output text)
  echo "Encrypted snapshot created: $encrypted_snapshot"

  # Wait for Encrypted Snapshot Completion
  echo "Waiting for encrypted snapshot to complete..."
  aws ec2 wait snapshot-completed --snapshot-ids $encrypted_snapshot --region $REGION

  # Create Encrypted Volume
  encrypted_volume=$(aws ec2 create-volume --snapshot-id $encrypted_snapshot --availability-zone $AVAILABILITY_ZONE --encrypted --region $REGION --query 'VolumeId' --output text)
  echo "Encrypted volume created: $encrypted_volume"

  # Wait for Volume to Become Available
  echo "Waiting for encrypted volume to become available..."
  aws ec2 wait volume-available --volume-ids $encrypted_volume --region $REGION

  # Detach Old Unencrypted Volume
  aws ec2 detach-volume --volume-id $vol --region $REGION
  echo "Detached unencrypted volume: $vol"

  # Wait for Detachment
  aws ec2 wait volume-available --volume-ids $vol --region $REGION

  # Attach New Encrypted Volume
  aws ec2 attach-volume --volume-id $encrypted_volume --instance-id $INSTANCE_ID --device /dev/xvda --region $REGION
  echo "Encrypted volume $encrypted_volume attached to instance $INSTANCE_ID."

done

# Start the EC2 Instance
aws ec2 start-instances --instance-ids $INSTANCE_ID --region $REGION
echo "Starting instance $INSTANCE_ID..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION
echo "Instance $INSTANCE_ID is running."
