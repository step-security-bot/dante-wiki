








* Install docker on target machine
* Add your user to the docker group.
  sudo usermod -aG docker ${USER}
* Log out and log in again
* Check 
  docker run hello-world


Clone the github repository

  git clone https://github.com/clecap/continuous-deployment-test


== Build Docker Containers ==

  container/ssh/bin/generate.sh
  container/tex/bin/generate.sh