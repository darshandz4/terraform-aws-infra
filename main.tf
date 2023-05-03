## creating AWS provider
provider "aws" {
	access_key="AKIA6RGBDWVGNSLN5A7N"
	secret_key="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"
	region="ap-south-1"
		}

#creating vpc
resource "aws_vpc" "test" {
	cidr_block="10.10.0.0/16"
	tags= {
		Name="my_vpc"
		}
			}
#creating sunnet
resource "aws_subnet" "sub-1" {
	vpc_id="${aws_vpc.test.id}"
	cidr_block="10.10.0.0/24"
	tags= {
		Name="my-sub-1"
		}
				}
resource "aws_subnet" "sub-2" {
	vpc_id="${aws_vpc.test.id}"
	cidr_block="10.10.1.0/24"
	tags= {
		Name="my-sub-2"
		}
				}
#creating internet gateway
resource "aws_internet_gateway" "igw" {
        vpc_id="${aws_vpc.test.id}"
	tags= {
		Name="my-igw"
		}
				}
# creating route table 
resource "aws_route_table" "route-table" {
	 vpc_id="${aws_vpc.test.id}"
	tags= {
		Name="my-route"
		}
	route {
	cidr_block="0.0.0.0/0"
	gateway_id="${aws_internet_gateway.igw.id}"
		}
					}
#route table association
resource "aws_route_table_association" "one" {
	subnet_id="${aws_subnet.sub-1.id}"
	route_table_id="${aws_route_table.route-table.id}"
						}
resource "aws_route_table_association" "two" {
        subnet_id="${aws_subnet.sub-2.id}"
        route_table_id="${aws_route_table.route-table.id}"
						}
#creating instance resouce
resource "aws_instance""my-instance" {
        ami="ami-022d03f649d12a49d"
        instance_type="t2.micro"
        tags= {
                Name="webserver"
		}
				}

# attch elastic ip 
resource "aws_eip" "ip" {
	instance="${aws_instance.my-instance.id}"
			}

