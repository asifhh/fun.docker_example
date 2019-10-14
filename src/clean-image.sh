#!/bin/bash

# Bring in the variables from SOLUTION file
#
# Determine if it is Mac OS and switch to use gxargs instead
CMD=xargs
if [ $(which system_profiler) ]; then
  CMD=gxargs
fi

export $(grep -v '^#' SOLUTION | ${CMD} -d '\n' | envsubst)
export $(grep -v '^#' MANIFEST | ${CMD} -d '\n' | envsubst)

docker rmi ${CONTAINER_REPO_URL}/${CONTAINER_NAME}:devel
