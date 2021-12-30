output "ec2_instance_ip" {
    value = aws_instance.my_public_server.public_ip
}

# resource "local_file" "ansible_cfg" {
#   content = templatefile("inventory.tmpl",
#     {
#       webserver = aws_instance.my_public_server.public_ip
      
#     }
#   )
#   filename = "inventory"
# }