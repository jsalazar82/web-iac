output "public_ip" {
  value = aws_instance.web.public_ip
  description = "IP pública de la instancia EC2"
}

output "url" {
  value = "http://${aws_instance.web.public_ip}"
  description = "URL de la aplicación web"
}
