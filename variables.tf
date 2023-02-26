variable "region" {
    type = string
    description = "region"
    default = "us-east-1"
}


variable "vpc-cidr-block" {
  type = string
  description = "vpc cidr block"
  default = "10.0.0.0/16"
}


variable "pub1-cidr-block" {
    type = string
    description = "pubsub1 cidr block"
    default = "10.0.1.0/24"
  
}


variable "pub2-cidr-block" {
    type = string
    description = "pubsub2 cidr block"
    default = "10.0.2.0/24"
  
}


variable "priv1-cidr-block" {
    type = string
    description = "privsub1 cidr block"
    default = "10.0.8.0/24"

  
}


variable "priv2-cidr-block" {
    type = string
    description = "privsub2 cidr block"
    default = "10.0.12.0/24"
  
}


variable "igw-cidr-block" {
    type = string
    description = "internet gateway cidr block"
    default = "0.0.0.0/0"
  
}


variable "ami_name" {
     type = string
     description = "server configuration"
     default = "ami-0f540e9f488cfa27d"

}     


variable "instance" {
     type = string
     description = "operating system"
     default = "t2.micro"
}     
