# Docker Best Practice #


* Using alpine, as this is the smallest Linux installation for docker available.

* Using a fixed version number instead of latest in the interest of a reproducible build.

* Cleaning up inside of the SAME RUN command is essential. Compare: https://stackoverflow.com/questions/38597955/what-docker-image-size-is-considered-too-large

* dockerfile VOLUME command may turn into a problem since this works only on aws EC2 but not on Fargate

* It is imperative that we use && as continuation and not ; in the dockerfile because we want to fail as early as possible and not continue throughout the rest.

* Use a .dockerignore and a COPY . . command to cut down on the number of layers.

* When we do not find a package using APK then we might look up the repository link at https://pkgs.alpinelinux.org/packages and we might add in /etc/apk/repositories the
information on which repository this is to be found. Check also https://www.hasanaltin.com/error-unable-to-select-packages-error-on-alpine-linux/