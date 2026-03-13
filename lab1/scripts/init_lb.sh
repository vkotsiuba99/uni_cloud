#!/bin/bash
apt-get update
apt-get install -y nginx

# Use Terraform template syntax for dynamic upstream generation
cat << 'NGINXEOF' > /etc/nginx/sites-available/default
upstream backend {
%{ for ip in backend_ips ~}
    server ${ip};
%{ endfor ~}
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
NGINXEOF

systemctl restart nginx
