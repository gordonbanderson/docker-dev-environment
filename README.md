# Docker development environment #

Contains the development environment required to build, run and develop the Foodkit API and consumer website.

## Getting started ##

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

You'll need to prepare both codebases by running `composer install` in each folder. After this, you can go ahead and 
bring up the Docker containers:

```
cd docker-dev-environment
./startFoodkitContainers.sh
```

You should now have an API server running on [http://localhost:8888](http://localhost:8888) and a consumer web server
running on [http://localhost:8889](http://localhost:8889).

##Bash Alias and Function Helpers
In order to avoid typing in long commands execute the following to add new aliases to your ~/.bashrc file.  This only
needs done once.

```
less helpers/bash-help > ~/.bashrc

```

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


