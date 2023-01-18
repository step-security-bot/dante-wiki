# Docker Best Practice #


* Using alpine, as this is the smallest Linux installation for docker available.

* Using a fixed version number instead of latest in the interest of a reproducible build.

* Cleaning up inside of the SAME RUN command is essential. Compare: https://stackoverflow.com/questions/38597955/what-docker-image-size-is-considered-too-large

* dockerfile VOLUME command may turn into a problem since this works only on aws EC2 but not on Fargate