data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "cit" {

  cidr_block = var.vpc_cidr
  tags = {
      Name = "${var.prefix}-vpc"
      
      owner       = var.owner

  }
}

# Internet Gateway 

resource "aws_internet_gateway" "cit" {
  vpc_id = aws_vpc.cit.id

  tags = {
    Name = "${var.prefix}-igw"
    
    owner       = "IT"
  }
}

# EIP for NAT Gateway

resource "aws_eip" "cit" {
  vpc = true
  tags = {
    Name = "${var.prefix}-nat-eip"
  }

}

# NAT Gateway

resource "aws_nat_gateway" "cit" {
  allocation_id = aws_eip.cit.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.prefix}-nat-gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.cit]
}



resource "aws_subnet" "web" {
  count = length(data.aws_availability_zones.available.zone_ids) 
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, count.index)
  vpc_id     = aws_vpc.cit.id
  cidr_block = element(var.web_subnet_CIDRs, count.index )

  tags = {
    Name = "${var.prefix}-web-${count.index}"
    
    owner       = var.owner

  }
}


resource "aws_subnet" "jenkins_worker" {
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  vpc_id     = aws_vpc.cit.id
  cidr_block = var.worker_subnet_CIDR 

  tags = {
    Name = "${var.prefix}-jenkins-worker"
    
    owner       = var.owner

  }
}


resource "aws_route_table_association" "jenkins_worker" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = aws_subnet.jenkins_worker.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cit.id

  route {
    
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.cit.id
   }

  tags = {
    Name = "${var.prefix}-Public_RT"
    
    owner       = "IT"
  }
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, count.index)
  vpc_id     = aws_vpc.cit.id
  cidr_block = element(var.public_subnet_CIDRs, count.index )

  tags = {
    Name = "${var.prefix}-public-${count.index}"
    
    owner       = var.owner 

  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cit.id

  route {
    
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.cit.id
   }

  tags = {
    Name = "${var.prefix}-Private_RT"
    
    owner       = "IT"
  }
}


resource "aws_route_table_association" "web" {
  count = length(data.aws_availability_zones.available.zone_ids)
  subnet_id      = element(aws_subnet.web.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


