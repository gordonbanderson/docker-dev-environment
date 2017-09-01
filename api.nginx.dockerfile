FROM nginx:1.10

ADD ./api.vhost.conf /etc/nginx/conf.d/default.conf
