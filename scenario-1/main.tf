provider "aws" {
    region = "eu-north-1"
    shared_config_files = ["$HOME/.aws/config"]
    shared_credentials_files = ["$HOME/.aws/credentials"]
}
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}
resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.terraform-vpc.id   
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "public-subnet-1"
    }
  
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.terraform-vpc.id 
    tags = {
        Name = "IGW"
    }  
}
resource "aws_route_table" "route-to-IGW" {
    vpc_id = aws_vpc.terraform-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}
resource "aws_route_table_association" "publicSubnet" {
    subnet_id = aws_subnet.public-subnet-1.id 
    route_table_id = aws_route_table.route-to-IGW.id 
    
}

resource "aws_security_group" "SG1" {
    name = "subnet-SG"
    vpc_id = aws_vpc.terraform-vpc.id
   
    ingress {
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}
resource "aws_instance" "app" {
    ami = "ami-064087b8d355e9051"
    instance_type = "t3.micro"
    key_name = "Mostafa-Key"
    subnet_id = aws_subnet.public-subnet-1.id 
    associate_public_ip_address = true
    vpc_security_group_ids = ["sg-0e306fac89f91f661"]
    user_data = <<-EOF
    #cloud-config
    packages:
      - apache2
    runcmd:
      - systemctl start apache2
      - systemctl enable apache2
  EOF
  
}