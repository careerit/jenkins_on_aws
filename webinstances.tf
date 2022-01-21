
resource "aws_network_interface" "web" {
  count = var.web_instance_count 
  subnet_id   = element(aws_subnet.web.*.id, count.index)
  security_groups = [aws_security_group.web.id]
  
  tags = {
    Name = "web_nic-${count.index}"
  }
}


resource "aws_instance" "web" {
  count  =  var.web_instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_instance_size
  
  network_interface {
    network_interface_id = element(aws_network_interface.web.*.id, count.index)
    device_index         = 0
  }
  
  credit_specification {
    cpu_credits = "unlimited"
  }
  key_name=var.keypair



  tags = {
    Name = "${var.prefix}-web-${count.index}"
    

  }
  depends_on = [aws_route_table_association.web]
}


