# Bring in the variables from SOLUTION file
#
# Determine if it is Mac OS and switch to use gxargs instead
CMD=xargs
if [ $(which system_profiler) ]; then
  CMD=gxargs
fi

export $(grep -v '^#' MANIFEST | ${CMD} -d '\n' | envsubst)
export $(grep -v '^#' SOLUTION | ${CMD} -d '\n' | envsubst)

docker build . -t ${CONTAINER_NAME}:${TAG} || {
cat << EOM

Building docker image failed.

EOM
  exit $?
}

docker tag ${CONTAINER_NAME}:${TAG} ${CONTAINER_NAME}
docker tag ${CONTAINER_NAME}:${TAG} ${CONTAINER_REPO_URL}/${CONTAINER_NAME}:devel
docker push ${CONTAINER_REPO_URL}/${CONTAINER_NAME}:devel
rc=$?
if [ $rc -ne 0 ]; then
  exit 1
fi

cat << EOM
The image was tagged as 'devel' and pushed to Harbor:

  amr-registry.caas.intel.com/vtt-osgc/solutions/${CONTAINER_NAME}:devel

If the build looks good, you should commit the changes to Dockerfile and tag it
as '${TAG}'.

  git commit -s -a -m "Build of ${TAG}"
  git tag -f ${TAG}

Run the following cmds in order to push to Harbor:

  docker tag ${CONTAINER_NAME}:${TAG} amr-registry.caas.intel.com/vtt-osgc/solutions/${CONTAINER_NAME}:${TAG} ;
  docker push amr-registry.caas.intel.com/vtt-osgc/solutions/${CONTAINER_NAME}:${TAG} ;

If this is a good build, then roll it to 'latest' tag as follows:

  docker tag ${CONTAINER_NAME}:${TAG} amr-registry.caas.intel.com/vtt-osgc/solutions/${CONTAINER_NAME}:latest ;
  docker push amr-registry.caas.intel.com/vtt-osgc/solutions/${CONTAINER_NAME}:latest ;

EOM
