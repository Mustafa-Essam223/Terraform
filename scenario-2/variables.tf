variable "vpc-name" {
    description = "vpc name"
    type = string
    default = "iti-vpc"
}
variable "vpc-cidr" {
    description = "iti-vpc cidr block"
    type = string

  
}
variable "subnet-names" {
  description = "this list of variables to give a name for each subnet"
  type = list 
}
variable "subnet-cidrs" {
  description = "this list of variables to give a cidr-block for each subnet"
  type = list
}
variable "subnet-avZones" {
  description = "this list of variables to give an availability-zone for each subnet"
  type = list
}
variable "IGW-Name" {
  description = "name of internet gateway"

}
variable "any-ip-cidr" {
}
variable "igw-route-terra" {
}

variable "security-group-names" {
  type = list
}
variable "sg-info" {
    type = list(tuple([number,number,string,string]))
}
variable "nat-name" {
  type = string
}
variable "nat-route-name" {
  
}
variable "instance-info" {
  type = list(tuple([string,string,string,bool,list(string),string]))
}
