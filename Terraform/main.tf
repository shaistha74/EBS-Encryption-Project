terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "EBS-Encryption-Instance"
  }
}

resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
}

resource "aws_volume_attachment" "attach_volume" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.unencrypted_volume.id
  instance_id = aws_instance.ec2_instance.id
}
