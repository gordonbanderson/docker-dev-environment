FROM postgres:9.6

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main" >> /etc/apt/sources.list' \
    && apt-get update -y \
    && apt-get install -y postgresql-9.6-postgis-2.3 less vim

ADD init-db.sh /docker-entrypoint-initdb.d/init-db.sh

RUN echo 'PS1="\[$(tput setaf 2)$(tput bold)[\]foodkit.db@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bashrc

