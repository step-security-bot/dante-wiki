


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







