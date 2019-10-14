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

  #
  # Common docker definition snippets.
  #
# Pull from the internal cache of images
FROM amr-registry.caas.intel.com/vtt-osgc/os/ubuntu:disco

  #
  # Common docker definition snippets.
  #
# Pre-install proxy configuration values
#
# This uses the linux-ftp.ostc.intel.com as a mirror.
RUN echo "Acquire::http::proxy \"http://proxy-chain.intel.com:911/\";\n" \
	"Acquire::https::proxy \"https://proxy-chain.intel.com:911/\";\n" \
	"Acquire::ftp::proxy \"ftp://proxy-chain.intel.com:911/\";\n" \
	"Acquire::socks::proxy \"socks://proxy-chain.intel.com:1080/\";\n" \
	"Acquire::http::Proxy::linux-ftp.ostc.intel.com DIRECT;\n" \
	"Acquire::http::Proxy::osgc.jf.intel.com DIRECT;\n" > /etc/apt/apt.conf

  #
  # Common docker definition snippets.
  #
# Install Intel CA5A cert so Intel certs are recognized

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    ca-certificates \
    wget \
    unzip \
  && mkdir -p /usr/local/share/ca-certificates \
  && wget -qO tmp.zip http://certificates.intel.com/repository/certificates/IntelSHA2RootChain-Base64.zip \
     && unzip tmp.zip -d /usr/local/share/ca-certificates \
     && rm tmp.zip \
  && wget -qO tmp.zip http://certificates.intel.com/repository/certificates/Intel%20Root%20Certificate%20Chain%20Base64.zip \
     && unzip tmp.zip -d /usr/local/share/ca-certificates \
     && rm tmp.zip \
  && update-ca-certificates --fresh


  #
  # Common docker definition snippets.
  #
# Update the repo lists and then install things using the internal
# sources. Packages used by many developers are pulled into this image
# but we do want it to be relatively small.
#
# NOTE: We use DEBIAN_FRONTEND=noninteractive to prevent krb5-user from
#       trying to prompt for configuration details during install.
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install \
    -y --no-install-recommends -q \
  net-tools \
  iputils-ping \
  sudo \
  wget \
  locales \
  software-properties-common

# Set up locales
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

  #
  # Common docker definition snippets.
  #
# Create user 'agama' and add them to 'sudo' for sudo access and set
# the passwd to 'agama'
#
# NOTE: Requires 'sudo' package to already be installed
RUN groupadd -r agama \
&& useradd --no-log-init \
  -s /bin/bash \
  -r -m \
  -g agama \
  -G sudo \
  -p $(echo "agama" | openssl passwd -stdin) agama

# Set 'sudo' to NOPASSWD for all container users
RUN sed -i -e 's,%sudo.*,%sudo ALL=(ALL) NOPASSWD:ALL,g' /etc/sudoers

  #
  # Common docker definition snippets.
  #
# Update and install gpg-agent as it isn't in the base Ubuntu image and is needed for apt-key
RUN apt-get -q update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -q -y install \
    gpg-agent

# Fetch and install the signing key for OSGC's Agama repository
RUN wget --no-proxy --quiet -O /tmp/aptly.key http://osgc.jf.intel.com/packages/agama/ubuntu/aptly_repo_signing.key \
  && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn apt-key add /tmp/aptly.key \
  && rm /tmp/aptly.key

# Add internal Agama repository
RUN apt-add-repository "deb [arch=amd64] http://osgc.jf.intel.com/packages/agama/ubuntu disco main"

# Update and install the Mesa, OpenCL, and Media from Agama
RUN apt-get -q update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -q -y install \
    intel-gmmlib \
    intel-igc-core \
    intel-igc-opencl \
    libgl1-mesa-glx19.1.0.agama-196 \
    libgl1-mesa-dri19.1.0.agama-196 \
    intel-opencl \
    intel-media \
    libva22.6.0.agama-196 \
    ocl-icd-libopencl1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


#
# Solution docker definition snippet.
#
#####
# This file is extremely custom and unique for each individual solution
# It gets added to the end of the build-docker script, https://gitlab.devtools.intel.com/vtt/sws/osgc/solutions/scripts/build-dockerfile.sh.

# General Example
# Update and install the Mesa, OpenCL, and Media
RUN apt-get -q update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -q -y install \
    ffmpeg clinfo

ENTRYPOINT ['/bin/bash']
CMD ['clinfo']

#
# Common end of docker definitions snippet.
#
# NOTE: This should be added as the last template entry
# as it will always modify a layer (since the Dockerfile
# changes,) causing all subsequent layers to be 
# regenerated.

# Clean up APT content that might still be around
#RUN apt-get clean autoclean \
#  && apt-get autoremove -y \
#  && rm -rf /var/lib/${apt,dpkg,cache,log}

# Ensure that each Docker container self-documents the 
# versions included in it

ENV AGAMA_VERSION=196

COPY LIBRARIES RELEASE Dockerfile /assets/
