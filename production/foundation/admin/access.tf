variable "public_key" {}

resource "aws_key_pair" "admin" {
  key_name = "admin"
  public_key = var.public_key
}

output "key_name" {
  value = aws_key_pair.admin.key_name
}
