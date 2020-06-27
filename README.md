# selenium-registration-failure

This project was created to debug the problem of occasional failure to register
Selenium Node to Selenium Hub.

Usage:

1. build the docker image

```shell
$ docker-compose build
```

2. make sure you have Selenium images available on your machine

```shell
$ docker-compose pull
```

3. run the verification loop with as many iterations as desired
```shell
$ ./run-loop.sh 1000
```
