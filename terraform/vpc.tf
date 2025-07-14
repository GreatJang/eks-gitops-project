# VPC 및 서브넷 구성

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(["ap-northeast-2a", "ap-northeast-2c"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  availability_zone = element(["ap-northeast-2a", "ap-northeast-2c"], count.index)

  tags = {
    Name = "eks-private-subnet-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "eks-nat"
  }
}

resource "aws_eip" "nat" {
}

#라우팅 테이블
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-public-rt"
  }
}

resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-private-rt"
  }
}

# 퍼블릭 라우팅 테이블에 퍼블릭 서브넷 연결
resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_subnets[0].id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnets[1].id
  route_table_id = aws_route_table.eks_public_rt.id
}

# 프라이빗 라우팅 테이블에 프라이빗 서브넷 연결
resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.eks_private_rt.id
}
