FROM nginx:1.10

ADD ./vhost.conf /etc/nginx/conf.d/default.conf
RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.cw.nginx@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc
