resource "null_resource" "runner_setup" {
  provisioner "local-exec" {
    command = "chmod +x ./run.sh && ./run.sh"
  }
}