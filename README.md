# Docker development environment #

Contains the development environment required to build, run and develop the Foodkit API and consumer website.

## Getting started - Installation and Helpers ##

### Install Docker ###
Install Docker. You can get it for [Windows](https://docs.docker.com/docker-for-windows/install/),
 [Mac OSX](https://docs.docker.com/docker-for-mac/install/), [Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) 
 and a range of other \*nix distributions.

To get started, you should place [this repository](https://github.com/foodkit/docker-dev-environment) in the *parent* folder of the `api` 
and `consumer-web` projects.

That is, your folder structure should be as such:

```
/parent-folder
  |- api
  |- consumer-web
  |- docker-dev-environment
```

###Install Bash Alias and Function Helpers
Execute the following comand to add new aliases to your ~/.bashrc file.  This *only needs done once*, as subsequently 
every time a terminal is opened ~/.bashrc will be executed.  This will import the docker dev envrionment helper functions
 also.  Run this from `/path/to/docker-dev-envrionment` - do not forget to use `>>` instead
of `>` or you will overwrite as opposed to append.

```bash
echo "source '${PWD}/helpers/bash-help'" >> ~/.bashrc
```

###Build Containers###
Execute the following command to either build or rebuild the containers.  The first time this is executed it may take
several minutes as docker images need to be downloaded, but for subsequent rebuilds they are cached.
```bash
./rebuildFoodkitContainers
```

This creates the following containers:
* foodkit.api.nginx - this is the webserver for the API and port forwards to localhost:8888
* foodkit.api - contains the foodkit app served by php-fpm.  Artisan tasks can be run here.
* foodkit.cw.nginx - this is the webserver for the consumer web and port forwards to localhost:8889
* foodkit.cw - this is the consumer web app
* foodkit.redis - redis server, for caching and sessions
* foodkit.beanstalk - beanstalkd server for queue mangagement

You can see if these are running by executing `sudo docker-compose ps`

###Get a Terminal for a Container
To get a terminal on any of the above, execute `dt <image_name>`.  For example

```
ginja@acer574:~/tools/foodkit/dockerdevtest/docker-dev-environment$ dt foodkit.api
[foodkit.api@1b45d06ee05e$:/var/www]#
```

Note that terminal prompts have the container name, except currently for redis and beanstalk.  In practice only
`foodkit.api` and `foodkit.cw` are useful, except when debugging installation issues.

###Get Service Logs for a Container
The alias `dl` allows one to get logs for a container service.  The alias acts like `tail -f` in a standard UNIX environment.
Note however that the logs are not persisted.

```
ginja@acer574:~/tools/foodkit/dockerdevtest/docker-dev-environment$ dl foodkit.api.nginx
172.18.0.1 - - [18/Sep/2017:04:28:15 +0000] "GET /admin/login HTTP/1.1" 200 5370 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
172.18.0.1 - - [18/Sep/2017:04:28:15 +0000] "GET /build/js/vendors-4a6792287a.js HTTP/1.1" 304 0 "http://localhost:8888/admin/login" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
172.18.0.1 - - [18/Sep/2017:04:28:15 +0000] "GET /build/js/admin-ce735c5b90.js HTTP/1.1" 304 0 "http://localhost:8888/admin/login" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
172.18.0.1 - - [18/Sep/2017:04:28:15 +0000] "GET /build/css/app-9f3d550412.css HTTP/1.1" 304 0 "http://localhost:8888/admin/login" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
172.18.0.1 - - [18/Sep/2017:04:28:17 +0000] "GET /fonts/patternfly//OpenSans-Regular-webfont.woff2 HTTP/1.1" 304 0 "http://localhost:8888/build/css/app-9f3d550412.css" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
172.18.0.1 - - [18/Sep/2017:04:28:17 +0000] "GET /fonts/patternfly//OpenSans-Semibold-webfont.woff2 HTTP/1.1" 304 0 "http://localhost:8888/build/css/app-9f3d550412.css" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.79 Safari/537.36" "-"
```




GBA: I think this needs done inside the containers
You'll need to prepare both codebases by running `composer install` in each folder. After this, you can go ahead and 
bring up the Docker containers:

```
cd docker-dev-environment
./startFoodkitContainers.sh
```

You should now have an API server running on [http://localhost:8888](http://localhost:8888) and a consumer web server
running on [http://localhost:8889](http://localhost:8889).





## Find the Faster Mirrors
On a Debian based machine, or from a container find the fastest mirror using this
```angular2html
sudo apt-get install netselect-apt
sudo netselect-apt -c thailand -t 20
```

(Note second command not working at time of writing)

## How do I... ##

### ...make code changes? ###

The scripts will add mount points on the containers that link directly back to the host file system. You can edit the
files in the `../consumer-web` and `../api` folders and they will be instantly reflected inside the Docker containers.

### ...run migrations? ###

```
docker-compose exec api-app php artisan migrate --force
```

### ...connect to the database? ###

The Docker configuration will port-forward PostGRES to 54321 on your local machine. You can connect using:

```
psql -U postgres -h localhost -p 54321
```

GBA: notes
```angular2html
createdb -U postgres -h localhost -p 54321 foodkitapi
dpsql foodkitapi
```

### ...clear the cache? ###

The Redis container is shared between API and website, so you only need to do it once for both:

```
docker-compose exec api-app php artisan cache:clear
```

### ...tail the logs? ###

For the API:

```
docker-compose exec api-app tail -f storage/logs/laravel.log
```

... and the website:

```
docker-compose exec consumer-web-app tail -f storage/logs/laravel.log
```

### ...run the tests? ###

@TODO

There's currently no easy way to do this apart from manually bootstrapping and running phpunit via `docker-compose exec...`.

### ... get a shell? ###
```
docker exec -ti foodkit.api /bin/bash
```

## Help! Something broke ##

You can check that all the processes are running as expected using the following command:

```
docker-compose ps
```

You should see a list of the containers:

```
      Name                     Command               State               Ports             
------------------------------------------------------------------------------------------
foodkit.api         /usr/sbin/sshd -D                Up      22/tcp, 9000/tcp              
foodkit.api.nginx   nginx -g daemon off;             Up      443/tcp, 0.0.0.0:8888->80/tcp 
foodkit.beanstalk   beanstalkd -p 11300              Up      0.0.0.0:32770->11300/tcp      
foodkit.cw          php-fpm                          Up      9000/tcp                      
foodkit.cw.nginx    nginx -g daemon off;             Up      443/tcp, 0.0.0.0:8889->80/tcp 
foodkit.db          docker-entrypoint.sh postgres    Up      0.0.0.0:54321->5432/tcp       
foodkit.redis       docker-entrypoint.sh redis ...   Up      0.0.0.0:32771->6379/tcp 
```

Look at the "state" column. If any of them are not "Up" that's probably where you want to start. You can check the log
for the container process using:

```
docker-compose logs api-app --follow
```

If all hope is lost, you can rebuild the containers:

```
# Stop and delete containers
docker-compose down

# Rebuild images:
docker-compose build

# Restart containers (daemonised):
docker-compose up -d
```

## Contributing ##

See the list of open issues [here](https://github.com/foodkit/docker-dev-environment/issues).


#TOFIX

[foodkit.api@69badc343178$:/var/www]# history
    1  psql -U postgres -h foodkit.db -p 5432
    2  apt-get install postgresql-client
    3  psql -U postgres -h foodkit.db -p 5432
    4  history

port forwarding not working

In container

psql -U postgres -h foodkit.db -p 5432 foodkitapi


