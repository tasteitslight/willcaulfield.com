server {
    server_name willcaulfield.com  www.willcaulfield.com;
    root /var/www/willcaulfield.com;

    index index.html index.htm index.php;

    location / {
        if ($request_uri ~ ^/(.*)\.html) {
            return 302 /$1;
        }
        try_files $uri $uri.html $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }


    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/willcaulfield.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/willcaulfield.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}
server {
    if ($host = www.willcaulfield.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = willcaulfield.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name willcaulfield.com  www.willcaulfield.com;
    #  return 404; # managed by Certbot




}
