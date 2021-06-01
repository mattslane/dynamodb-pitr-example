variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-1"
}

variable "read_capacity" {
    type = number
    description = "read capacity for dynamodb table"
    default = 5
}

variable "write_capacity" {
    type = number
    description = "read capacity for dynamodb table"
    default = 200
}
