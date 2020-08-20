resource "null_resource" "example2" {
    provisioner "local-exec" {
        command = ["/bin/bash", "-c", "setup.sh"]
    }
}