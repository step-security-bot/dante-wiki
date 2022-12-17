#!/bin/bash

# This file defines those content elements of volumes/full which are under control of a local git
# That way we can work on minor parts of dante mediawiki without always having to generate a big repository for a tiny extension or skin

# NOTE: Shell lists do not have a comma separator

declare -a MY_FILES=("DanteSettings.php")

declare -a MY_DIRECTORIES=("extensions/DanteBread"   "extensions/DantePresentations"  "extensions/DanteSyntax"  "skins/skinny"  "skins/DantePresentationSkin")
