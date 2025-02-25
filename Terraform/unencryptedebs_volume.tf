resource "aws_ebs_volume" "unencrypted_volume1" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  encrypted         = false # ✅ Explicitly unencrypted

  tags = {
    Name = "Unencrypted-Volume1"
  }
}
