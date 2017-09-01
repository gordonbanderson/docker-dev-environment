# Docker development environment #

Contains the development environment required to build, run and develop the Foodkit API and consumer website.

## Getting started ##

Install Docker. You can get it for [Windows](https://docs.docker.com/docker-for-windows/install/), [Mac OSX](https://docs.docker.com/docker-for-mac/install/), [Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) and a range of other \*nix distributions.

To get started, you should place [this repository](https://github.com/foodkit/docker-dev-environment) in the *parent* folder of the `api` and `consumer-web` projects.

That is, your folder structure should be as such:

```
- parent
  |- api
  |- consumer-web
  |- docker-dev-environment
```

Make sure your two codebases are prep'ed and ready to run (do any `composer install`ing or `.env` setup), then go ahead and bring up Docker:

```
cd docker-dev-environment
docker-compose up -d
```
