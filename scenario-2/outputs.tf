output "vpc-name" {
    value = var.vpc-name
}
output "vpc-cidr-range" {
    value = var.vpc-cidr
}
output "public-sg-id" {
  value = aws_security_group.public-sg.id
  
}

output "private-sg-id" {
  value = aws_security_group.private-sg.id
}
