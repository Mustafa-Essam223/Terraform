vpc-name = "iti-vpc-terraform"
vpc-cidr = "10.0.0.0/16"
subnet-names = ["public-subnet-","private-subnet-"]
subnet-cidrs = ["10.0.0.0/24","10.0.1.0/24"]
subnet-avZones = ["eu-north-1a","eu-north-1b"]
IGW-Name = "iti-igw-terraform"
any-ip-cidr = "0.0.0.0/0"
igw-route-terra = "igw-route-terra"
security-group-names = ["public-SG-terraform","private-SG-terraform"]
sg-info = [ [0,0,"-1","0.0.0.0/0"] , [0,0,"-1","0.0.0.0/0"] ]
nat-name  = "NAT-1-Terraform"
nat-route-name = "nat-route-terra"

instance-info = [ 
    # replace the security group id with public-sg-id,private-sg-id of output in console
[ "ami-064087b8d355e9051","t3.micro","Mostafa-Key",true, ["sg-077329dc0db4559be"],"public-proxy"]
,[ "ami-064087b8d355e9051","t3.micro","Mostafa-Key",false,["sg-03b430cc2e18167c1"] ,"private-app"] 
]



