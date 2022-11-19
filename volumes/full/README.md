


volumes/full is a full blown mediawiki plus wordpress development environment

/content contains the contents which is mounted by the lap container and it is throw away

/own contains own development - do not throw away



/spec contains shell scripts and tar / zip files which allow to reconstruct content as we need it from various sources

* vendor: What others have developed. We cache it here and also could pull it from repositories.
* internet:
* own: We developed and we pull it from here for speed / convenience. We could also pull it from github repositories.
* modified: We modified it.