data "template_file" "worker" {
  template = file("${path.module}/Templates/worker.tpl")
}

resource "aws_instance" "worker" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.jenkins_worker_size
  key_name=var.keypair
  network_interface {
    network_interface_id = aws_network_interface.worker.id
    device_index         = 0
  }
  user_data = data.template_file.jenkins.rendered
  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name        = "${var.prefix}-worker"
    owner       = var.owner  

  }
  depends_on = [aws_instance.jenkinsmain, aws_route_table_association.public]
}


resource "aws_network_interface" "worker" {  
  subnet_id   = aws_subnet.jenkins_worker.id
  security_groups = [aws_security_group.worker.id]
  
  tags = {
    Name = "${var.prefix}-worker-nic"
  }
}
