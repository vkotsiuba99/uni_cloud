#!/bin/bash
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 5; done
while fuser /var/lib/apt/lists/lock >/dev/null 2>&1; do sleep 5; done

apt-get update
apt-get install -y nginx

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
