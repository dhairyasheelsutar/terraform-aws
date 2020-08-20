resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = <<-EOF
                #!/bin/bash
                aws s3 cp s3://bucket-20942/db_credentials.sh .
                chmod +x db_credentials.sh
                source db_credentials.sh
                EOF
  }
}