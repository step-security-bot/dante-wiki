








* Install docker on target machine
* Add your user to the docker group.
  sudo usermod -aG docker ${USER}
* Log out and log in again
* Check 
  docker run hello-world


We are not using buildx.

in ~user/.docker make a file

  {  "features": { "buildkit": false } }


Restart docker:

  sudo service docher restart



Clone the github repository

  git clone https://github.com/clecap/continuous-deployment-test






== Build Docker Containers ==

  containers/ssh/bin/prepare.sh
  containers/ssh/bin/generate.sh
  containers/ssh/bin/postpare.sh



  containers/tex/bin/generate.sh