output "instance_id" {
  value = aws_instance.ec2_instance.id
}

output "volume_id" {
  value = aws_ebs_volume.unencrypted_volume.id
}