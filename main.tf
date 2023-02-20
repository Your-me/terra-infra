resource "aws_vpc" "Terraform-vpc" {
  cidr_block       = var.vpc-cidr-block
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-vpc"
  }
}


resource "aws_subnet" "Terra-pubsub1" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.pub1-cidr-block

  tags = {
    Name = "Terra-pubsub1"
  }
}


resource "aws_subnet" "Terra-pubsub2" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.pub2-cidr-block

  tags = {
    Name = "Terra-pubsub2"
  }
}


resource "aws_subnet" "Terra-privsub1" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.priv1-cidr-block

  tags = {
    Name = "Terra-privsub1"
  }
}


resource "aws_subnet" "Terra-privsub2" {
  vpc_id     = aws_vpc.Terraform-vpc.id
  cidr_block = var.priv2-cidr-block

  tags = {
    Name = "Terra-privsub2"
  }
}


resource "aws_route_table" "Terra-pub-route-table" {
  vpc_id = aws_vpc.Terraform-vpc.id

  tags = {
    Name = "Terra-pub-route-table"
  }
}


resource "aws_route_table" "Terra-priv-route-table" {
  vpc_id = aws_vpc.Terraform-vpc.id

  tags = {
    Name = "Terra-priv-route-table"
  }
}


resource "aws_route_table_association" "Pub-Terra-route-table-association1" {
  subnet_id      = aws_subnet.Terra-pubsub1.id
  route_table_id = aws_route_table.Terra-pub-route-table.id
}


resource "aws_route_table_association" "Pub-Terra-route-table-association2" {
  subnet_id      = aws_subnet.Terra-pubsub2.id
  route_table_id = aws_route_table.Terra-pub-route-table.id
}


resource "aws_route_table_association" "Priv-Terra-route-table-association1" {
  subnet_id      = aws_subnet.Terra-privsub1.id
  route_table_id = aws_route_table.Terra-priv-route-table.id
}


resource "aws_route_table_association" "Priv-Terra-route-table-association2" {
  subnet_id      = aws_subnet.Terra-privsub2.id
  route_table_id = aws_route_table.Terra-priv-route-table.id
}


resource "aws_internet_gateway" "Terra-igw" {
  vpc_id = aws_vpc.Terraform-vpc.id

  tags = {
    Name = "Terra-igw"
  }
}


resource "aws_route" "Pub-Terra-igw-route" {
  route_table_id            = aws_route_table.Terra-pub-route-table.id
  destination_cidr_block    = var.igw-cidr-block
  gateway_id                = aws_internet_gateway.Terra-igw.id
} 


resource "aws_eip" "Test-nat-eip" {
  vpc      = true
  tags = {
  }
}


 resource "aws_nat_gateway" "Terra-Nat-gateway" {
  allocation_id = aws_eip.Test-nat-eip.id
  subnet_id     = aws_subnet.Terra-pubsub1.id

  tags = {
    Name = "Terra-Nat-gateway"
  }
  
}


resource "aws_security_group" "Terra-sec-group" {
  name        = "Terra-sec-group"
  description = "security group"

  vpc_id      = aws_vpc.Terraform-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }


  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["86.152.213.43/32"]
  }


egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Terra-sec-group"
  }
}

resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}

resource "aws_instance" "Terra-serve-1" {
  ami           = var.ami_name
  key_name = "tf-key-pair"
  subnet_id = aws_subnet.Terra-pubsub1.id
  instance_type = var.instance
  vpc_security_group_ids = [aws_security_group.Terra-sec-group.id] 
  }


resource "aws_instance" "Terra-serve-2" {
  ami           = var.ami_name
  key_name = "tf-key-pair"
  subnet_id = aws_subnet.Terra-privsub1.id
  instance_type = var.instance
  vpc_security_group_ids = [aws_security_group.Terra-sec-group.id] 
  }