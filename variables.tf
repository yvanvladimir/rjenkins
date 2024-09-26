variable "aws_region" {
  type        = string
  description = "AWS Region Name"
  default     = "us-east-1"
}
 
variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}
 
variable "vpc_public_subnets_cidr_block" {
  type        = string
  description = "CIDR Block for Public subnets in VPC"
  default     = "10.0.0.0/24"
}
 
variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}
 
variable "instance_type" {
  type        = string
  description = "Type of EC2 Instance"
  default     = "t3.micro"
}
 
variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "f2i"
}
 
variable "project" {
  type        = string
  description = "Project name for resource tagging"
  # NO default Value
}
 
variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
  default     = "039612887448"
}
