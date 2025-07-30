#!/bin/bash

# Actualización del sistema
sudo dnf update -y

# Instalar Node.js 18 y otras dependencias
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo dnf install -y nodejs git nginx

# Instalación PM2 de manera global
sudo npm install -g pm2

# Clona la aplicación desde GitHub y se ubica en el directorio adecuado
cd /home/ec2-user
sudo git clone https://github.com/jsalazar82/web-iac.git
cd web-iac
cd app


# Permisos al usuario para controlar los archivos descargados del repositorio
sudo chmod -R 755 /home/ec2-user/web-iac/app
sudo chown -R ec2-user:ec2-user /home/ec2-user/web-iac/app

# Instala dependencia Node.js
npm install

# Inicia la aplicación con PM2
pm2 start index.js --name "web-iac"

# Configura PM2 para iniciar en cada reinicio del sistema
pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save

# Configura Nginx como proxy reverso al puerto 3000
sudo tee /etc/nginx/conf.d/nodeapp.conf > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Habilita y reinicia Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
