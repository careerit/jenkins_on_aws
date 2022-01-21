data "template_file" "jenkins" {
  template = file("${path.module}/Templates/jenkins.tpl")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkinsmain" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.jenkins_main_size
  key_name=var.keypair
  network_interface {
    network_interface_id = aws_network_interface.jenkinsmain.id
    device_index         = 0
  }
  user_data = data.template_file.jenkins.rendered
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name        = "${var.prefix}-jenkinsmain"
    owner       = var.owner  

  }
  depends_on = [aws_route_table_association.public, aws_eip.jenkinsmain]
}


resource "aws_network_interface" "jenkinsmain" {  
  subnet_id   = aws_subnet.public[0].id
  security_groups = [aws_security_group.jenkins.id]
  
  tags = {
    Name = "jenkinsmain_nic"
  }
}


resource "aws_eip" "jenkinsmain" {
  vpc                       = true
  network_interface         = aws_network_interface.jenkinsmain.id
  depends_on                = [aws_internet_gateway.cit]

  }
