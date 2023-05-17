

## Requirements on target machine

### 1. Install Docker on the target machine
* Follow the instructions at 
* Add your user to the docker group: ```sudo usermod -aG docker ${USER}```
* Log out and log in again as ${USER}
* Check if docker is operative: ```docker run hello-world```


### 2. Install git and git credential manager on the target machine
* For Linux/Debian see: https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/install.md and follow Debian instructions
* Get a github permission token
* Configure helper according to https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git


### 4. Clone the github repository

  ```git clone https://github.com/clecap/continuous-deployment-test ```

## Build Docker Images

In directory /containers/ssh/bin run:
```
  prepare.sh
  generate.sh
  run.sh
  postpare.sh
```

Build tex image, based on ssh image: ```containers/tex/bin/generate.sh```

Build linux-apache-php image, based on tex image: ```containers/lap/bin/generate.sh```

Build mysql image: ```containers/my-mysql/bin/generate.sh```

Build a directory serving as template for the working volume for the lap container: ```volumes/full/spec/cmd.sh```

## Case 1: Run on volume identical to a host directory

Run both processes: ```containers/lap/bin/both.sh --db my-test-db-volume --dir full```

Test: wget --no-check-certificate

## Case 2: Run on volume as seperate docker volume

Prepare the docker volume: ```volumes/bin/add-dir.sh full sample-volume /html```



## Configure, patch and initialize

Prepare file ```conf/customize-PRIVATE.sh``` following ```customize-SAMPLE.sh```

Prepare file ```conf/mediawiki-PRIVATE.php``` following ```mediawiki-SAMPLE.php```


Pull Dante Patches from github: ```volumes/full/spec/git-pull-from-delta.sh```

Install Parsifal: ```volumes/full/spec/git-clone-dante-from-parsifal.sh```

Initialize Wiki: ```volumes/full/spec/wiki-init.sh```



## Look into docker container

On the machine:  ```docker exec -it CONTAINER_NAME /bin/ash```

From outside:  ssh -i login-key -p 2222 cap@localhost

login-key is to be found on /containers/ssh of the machine on which the container was run (do not confuse machines !)



## Look into containers

ssh:
tex:


my-mysql:  ssh -i login-key cap@IP-OF-MY-MYSQL-CONTAINER‚



wget --no-check-certificate



