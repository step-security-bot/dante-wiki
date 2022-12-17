
Directory ssh contains a minimal training ground for generating and running a docker image with alpine and secure shell entry into the system.



### Build ###
Generate a public, private key pair that we shall use for logging in tino the container.
```
ssh-keygen -f ssh-container
cp ssh-container.pub src
```

``` 
docker build -t ssh src
```

### Run ###
```
docker run -d --name SOME_NAME --network bridge -p:22:22 ssh 

-d is for detached
--name provides container with a fresh name
makes ssh port of container available at port 22 at localhost (provided this port is free)
```


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