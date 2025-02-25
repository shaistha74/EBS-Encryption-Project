variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone where the instance will be launched"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  default     = "ami-05b10e08d247fb927"
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "volume_size" {
  description = "The size of the EBS volume in GB"
  type        = number
}

variable "volume_type" {
  description = "The type of the EBS volume (e.g., gp2, gp3, io1)"
  type        = string
  default     = "gp3" # You can change this default if needed
}