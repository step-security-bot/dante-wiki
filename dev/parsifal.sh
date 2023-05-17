#!/bin/bash

# pull new stuff into container
docker exec -it my-lap-container /bin/ash


# and pull new stuff into volume
../volumes/full/spec/git-clone-dante-from-parsifal.sh
