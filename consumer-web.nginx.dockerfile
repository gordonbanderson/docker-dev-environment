FROM nginx:1.10

ADD ./consumer-web.vhost.conf /etc/nginx/conf.d/default.conf
