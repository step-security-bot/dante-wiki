# container/ssh-insecure

Directory ssh-insecure contains a minimal training ground for generating and running a docker image with alpine and secure shell entry into the system.

The chosen approach is insecure since we have the password in the dockerfile.

### Build ###
```
docker build -t ssh-insecure src
```

### Run ###
```
docker run -d --name SOME_NAME --network bridge -p 22:22 ssh-insecure 

-d is for detached
--name provides container with a fresh name
makes ssh port of container available at port 22 at localhost (provided this port is free)
```

### Retract ssh fingerprint for localhost ###
```
ssh-keygen -R localhost
```