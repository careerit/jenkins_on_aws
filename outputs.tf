output "jenkins_IP" {
    value = aws_eip.jenkinsmain.public_ip
}

output "web_IPs" {
    value = aws_instance.web.*.private_ip
}

output "worker_IPs" {
    value = aws_instance.worker.*.private_ip
}