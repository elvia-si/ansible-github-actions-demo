output "ec2_instance_ip" {
    value = aws_instance.my_public_server.public_ip
}

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      webserver = aws_instance.my_public_server.public_ip
      
    }
  )
  filename = "../ansible/inventory/hosts.cfg"
}