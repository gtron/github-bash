#!/bin/bash
#
# requires:
#  bash
#
# description:
#  GitHub API Client
#

set -e

set -o pipefail


function get_realpath() {

    link="$1"
	while [ -L "$link" ]; do
	  lastLink="$link"
	  link=$(/bin/ls -ldq "$link")
	  link="${link##* -> }"
	  link=$(realpath "$link")
	  [ "$link" == "$lastlink" ] && >&2 echo -e "ERROR: link loop detected on $link" && return 1 # error
	done
	
	echo $link
	
    return 0 # success

}


# include files

BASENAME=$(cd $(dirname "$(get_realpath $0)") && pwd -P)


. ${BASENAME}/lib/initializer.sh

# main

run_cmd ${COMMAND_ARGS}
