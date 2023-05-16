


## Install Docker on the target machine
* Follow the instructions at 
* Add your user to the docker group: ```sudo usermod -aG docker ${USER}```
* Log out and log in again as ${USER}
* Check if docker is operative: ```docker run hello-world```

## Clone the github repository

  ```git clone https://github.com/clecap/continuous-deployment-test ```

## Build Docker Containers

In directory /containers/ssh/bin run:
```
  prepare.sh
  generate.sh
  run.sh
  postpare.sh
```

In directory /containers/tex/bin run:
```
generate.sh
```

In directory /containers/lap/bin run:

```
generate.sh
```


In directory /containers/my-mysql/bin run:

```
generate.sh
```

In directory /container/lap/bin run:

```
generate.sh
```


Generate volume: ```volumes/full/spec/cmd.sh```


Run both processes: ```containers/lap/bin/both.sh --db my-test-db-volume --dir full```

Test: wget --no-check-certificate

volumes/full/spec/git-pull-from-delta.sh

## Look into docker container

On the machine:  ```docker exec -it CONTAINER_NAME /bin/ash```

From outside:  ssh -i login-key -p 2222 cap@localhost

login-key is to be found on /containers/ssh of the machine on which the container was run (do not confuse machines !)



## Look into containers

ssh:
tex:


my-mysql:  ssh -i login-key cap@IP-OF-MY-MYSQL-CONTAINER‚



wget --no-check-certificate



