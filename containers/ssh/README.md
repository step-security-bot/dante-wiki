
Directory ssh contains a minimal training ground for generating and running a docker image with alpine and secure shell entry into the system.



### Cheat Sheet ###

#### Preparing an Image ####
```
# we must be in the main directory containers/ssh

# generate a universal public, private key pair that we shall use for logging in into EVERY container running this image
bin/prepare.sh

# generate the docker image
bin/generate.sh

# 
bin/postpare.sh
```  

#### Running an Image as a Container ####


### Run ###


```
docker cp SOME_NAME:/etc/ssh/ssh_host_rsa_key.pub ./container-host-key-rsa.pub
docker cp SOME_NAME:/etc/ssh/ssh_host_ecdsa_key.pub ./container-host-key-ecdsa.pub

```


### Retract ssh fingerprint for localhost ###
```
ssh-keygen -R localhost
echo "localhost " `cat container-host-key-rsa.pub` >> ~/.ssh/known_hosts
echo "localhost " `cat container-host-key-ecdsa.pub` >> ~/.ssh/known_hosts
```


ssh -i ssh-container cap@localhost

16.7 MB