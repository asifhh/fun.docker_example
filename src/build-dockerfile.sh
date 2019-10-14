# Bring in the variables from the the SOLUTION and MANIFEST files.
#
# Determine if it is Mac OS and switch to use gxargs instead

CMD=xargs
if [ $(which system_profiler) ]; then
  CMD=gxargs
fi

export $(grep -v '^#' MANIFEST | ${CMD} -d '\n' | envsubst)
export $(grep -v '^#' SOLUTION | ${CMD} -d '\n' | envsubst)

# Remove the Dockerfile if it exists; should check
# if it is clean first, and abort if not.
#
[ -e Dockerfile ] && rm Dockerfile

cat << EOM > Dockerfile
#
# DO NOT EDIT THIS DOCKERFILE
#
# This file is auto-generated via scripts/build-dockerfile
# by using environment substitution while concatenating the
# contents of templates/*, and then adding the contents
# of Dockerfile.solution
#
# Most solution specific changes should be isolated in
# Dockerfile.solution. After making changes, you can
# then re-run scripts/build-dockerfile
#
EOM

for snippet in ../common/??-*.docker ; do
  cat << EOM >> Dockerfile

  #
  # Common docker definition snippets.
  #
EOM
  envsubst < $snippet >> Dockerfile
done

cat << EOM >> Dockerfile

#
# Solution docker definition snippet.
#
EOM

envsubst < ./solution.docker >> Dockerfile

cat << EOM >> Dockerfile

#
# Common end of docker definitions snippet.
#
EOM

envsubst < ../common/end.docker >> Dockerfile

cat << EOM

Dockerfile has been updated.

EOM
