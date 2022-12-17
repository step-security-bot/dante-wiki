# volumes/full #

`volumes/full` is the working area a full blown dante / mediawiki / parsifal plus wordpress development environment.

### Sub-Directories ###
It consists of the following sub-directories:

* `/content`: This is the area we are using. This is the mount point for the directory or volume.
* `/spec` contains shell scripts for reconstructing the content as we need it from three sources

### Content-Source ###
Where does the content come from?
* The internet (mediawiki.org, wordpress.org and others)
* The `src` directory (this is under control of github.com/clecap/continuous-deployment-test)
  * Contains a few 
* github.com/clecap/dante-delta
* github.com/Parsifal
* Possibly later other repositories


### Content-Construction ###
* `cmd.sh` pulls in various sources of mediawiki, wordpress etc from the network as well as from directory `/src`
*  



The

