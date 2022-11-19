
LAP is a LINUX APACHE PHP stack (without MySQL or other DB), configured for the purposes of the DANTE project.


# Usage

`generate.sh` generate the image from the dockerfile and docker context in /src



# Additional Files #

## Apache ##

### httpd.conf ###
* In the Alpine configuration, httpd.conf loads a number of modules, which we do not want to have loaded.
* We cannot prevent this using later config files since conf.d is loaded later.
* Patching using this using sed is unreliable so we decided to copy in the complete httpd.conf file.
* Therefore we upload a (minimally) patched hgttpd.conf where we take out the unwanted modules.
* Here: Disable those in conflict with php (see https://stackoverflow.com/questions/42506956/sudo-a2enmod-php5-6-php-v-still-shows-php-7-01-conflict )
**  Disable: mpm_prefork mpm_worker mpm_event
 
  
### all-my-config.conf
* All the other things are then adjusted / added in in my-config.conf inside of conf.d
* Note the name (conf.d is read in alphabetically)

### Info ###
* The modules are in /usr/lib/apache2


## Conventions ##
For Dante we use the following conventions:

/var/www/html is the starting point for the served pages.

/var/www/html/wiki-${NAME} is the starting point for the wiki of name ${NAME}

${NAME} conforms to [a-zA-Z0-9_]+


/var/www/html/dir is the starting point for directories which were bound in



