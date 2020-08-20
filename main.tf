resource "null_resource" "example2" {
    provisioner "local-exec" {
        command = "chmod +x setup.sh && ./setup.sh"
    }
}