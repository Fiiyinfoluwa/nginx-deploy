#!/bin/bash
apt update && apt upgrade -y && apt install nginx -y && apt install nodejs -y && apt install git -y && apt install certbot -y && apt install python3-certbot-nginx -y && apt install npm -y

git clone https://github.com/Fiiyinfoluwa/nginx-deploy.git

cd nginx-deploy

npm install

npm i pm2 -g

pm2 start app.js

pm2 startup systemd

env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u root --hp /root

pm2 save

systemctl start pm2-root

mkdir -p /var/www/fiiyinfoluwa.live/html

echo 'server {
        listen 80;
        listen [::]:80;

        root /var/www/fiiyinfoluwa.live/html;
        index index.html index.htm index.nginx-debian.html;

        server_name fiiyinfoluwa.live www.fiiyinfoluwa.live;

        location / {
                proxy_pass http://localhost:5000;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
        }
}' > /etc/nginx/sites-available/fiiyinfoluwa.live

ln -s /etc/nginx/sites-available/fiiyinfoluwa.live /etc/nginx/sites-enabled/

rm /etc/nginx/sites-enabled/default

systemctl restart nginx
