variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "CIT"
}


variable "region" {
  type        = string
  description = "Region where resources can be created"

}


variable "vpc_cidr" {
  type        = string
  description = "CIDR Range of the VPC"
  default     = "10.0.0.0/16"
}


variable "jenkins_main_size" {
  type    = string
  default = "t2.micro"
}

variable "jenkins_worker_size" {
  type    = string
  default = "t2.micro"
}

variable "web_instance_size" {

  description = "Size of the Web Instances"
}

variable "owner" {
  type = string
  # default = "IT"
}

variable "worker_count" {
  type    = number
  default = 3
}


variable "web_instance_count" {
  type    = number
  default = 4
}


variable "keypair" {
  description = "Keypair for authentication"
  default     = "cloudopsuseast1"
}

variable "public_subnet_CIDRs" {
  type = list(any)
  default = [
    "10.0.10.0/24",
    "10.0.20.0/24",
    "10.0.30.0/24",
    "10.0.40.0/24",
    "10.0.50.0/24",
    "10.0.60.0/24"
  ]

}

variable "worker_subnet_CIDR" {
  type = string
  default =  "10.0.10.0/24"
}

variable "web_subnet_CIDRs" {
  type = list(any)
  default = [
    "10.0.5.0/24",
    "10.0.15.0/24",
    "10.0.25.0/24",
    "10.0.35.0/24",
    "10.0.45.0/24",
    "10.0.55.0/24"
  ]

}