variable "region" {
  default = "ap-south-1"
  description=  "aws region for vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description=  "cidr range for vpc"
  type = string
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "instance_type" {
  description=  "aws ec2 instance type"
  default = "t2.micro"
}

variable "ubuntu_image" {
  description=  "aws ec2 instance ami"
  default ="ami-03bb6d83c60fc5f7c"
}