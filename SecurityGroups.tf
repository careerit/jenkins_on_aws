resource "aws_security_group" "web" {
  name        = "${var.prefix}-web-sg"
  description = "Allow SSH & HTTP inbound traffic"
  vpc_id      = aws_vpc.cit.id
  tags = {
      Name = "${var.prefix}-web-sg"
      
      owner = var.owner
  }
}


resource "aws_security_group_rule" "HTTP_to_LB" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"  
  source_security_group_id = aws_security_group.lb_sg.id
  security_group_id = aws_security_group.web.id
}



resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.web.id

}


resource "aws_security_group_rule" "SSH_TO_jenkins" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.web.id
  source_security_group_id = aws_security_group.jenkins.id
}




# jenkins Security Group


resource "aws_security_group" "jenkins" {
  name        = "${var.prefix}-jenkins-sg"
  description = "Allow SSH to Home"
  vpc_id      = aws_vpc.cit.id
  tags = {
      Name = "${var.prefix}-jenkins-sg"
      
      owner = var.owner
  }
}

resource "aws_security_group_rule" "SSH" {
  type              = "ingress"
  cidr_blocks       = ["45.117.65.87/32"]  
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.jenkins.id
}


resource "aws_security_group_rule" "jenkins" {
  type              = "ingress"
  cidr_blocks       = ["45.117.65.87/32"]  
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  security_group_id = aws_security_group.jenkins.id
}


resource "aws_security_group_rule" "master_to_worker" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  source_security_group_id = aws_security_group.worker.id
  security_group_id = aws_security_group.jenkins.id

}

resource "aws_security_group_rule" "allow_all_jenkins" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.jenkins.id

}


resource "aws_security_group" "worker" {
  name        = "${var.prefix}-worker-sg"
  description = "Allow SSH to Home"
  vpc_id      = aws_vpc.cit.id
  tags = {
      Name = "${var.prefix}-worker-sg"
      
      owner = var.owner
  }
}


resource "aws_security_group_rule" "worker_to_master" {
  type              = "ingress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  source_security_group_id = aws_security_group.jenkins.id
  security_group_id = aws_security_group.worker.id

}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.worker.id

}



resource "aws_security_group" "lb_sg" {
  name        = "${var.prefix}-lb-sg"
  description = "HTTP inbound traffic"
  vpc_id      = aws_vpc.cit.id
  tags = {
      Name = "${var.prefix}-lb-sg"
      
      owner = var.owner
  }
}

resource "aws_security_group_rule" "HTTP_LB" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "allow_all_lb" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"  
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.lb_sg.id

}



