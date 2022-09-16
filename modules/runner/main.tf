resource "null_resource" "example" {
    connection {
        type = "ssh"
        user = "testadmin"
        password = "Password1234!"
        host = data.azurerm_public_ip.data_ip.ip_address
        private_key = "${file("~/.ssh/id_rsa")}"
        port = 22
    }
    provisioner "file" {
      source = "start.sh"
      destination = "/tmp/start.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "/bin/bash /tmp/start.sh"
        ]
    }

    depends_on = [
      azurerm_virtual_machine.netframe_vm
    ]
}