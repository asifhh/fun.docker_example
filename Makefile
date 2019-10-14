SHELL := /bin/bash

CMD_BUILD_DOCKERFILE  := ${PWD}/src/build-dockerfile.sh
CMD_BUILD_DOCKERIMAGE := ${PWD}/src/build-image.sh
CMD_CLEAN_DOCKERIMAGE := ${PWD}/src/clean-image.sh

help:
	@echo "Make Targets" ;
	@echo "============" ;
	@echo "build_dockerfile_ubuntu_disco" ;
	@echo "clean_dockerfile_ubuntu_disco" ;
	@echo "build_dockerimage_ubuntu_disco" ;
	@echo "clean_dockerimage_ubuntu_disco" ;

build_dockerfile_ubuntu_disco:
	@export OS_DISTRO=ubuntu ; \
	export OS_RELEASE=disco ; \
	make build_dockerfile ;

build_dockerfile:
	@echo "Building ${OS_DISTRO} ${OS_RELEASE} Dockerfile ..." ; \
	cd osv/${OS_DISTRO}/${OS_RELEASE} ; \
	bash ${CMD_BUILD_DOCKERFILE} ;

clean_dockerfile_ubuntu_disco:
	@export OS_DISTRO=ubuntu ; \
	export OS_RELEASE=disco ; \
	make clean_dockerfile ;

clean_dockerfile:
	@echo "Cleaning ${OS_DISTRO} ${OS_RELEASE} Dockerfile ..." ; \
	cd osv/${OS_DISTRO}/${OS_RELEASE} ; \
	rm -f Dockerfile ;

build_dockerimage_ubuntu_disco:
	@export OS_DISTRO=ubuntu ; \
	export OS_RELEASE=disco ; \
	make build_dockerimage ;

build_dockerimage:
	@echo "Building ${OS_DISTRO} ${OS_RELEASE} Dockerimage ..." ; \
	cd osv/${OS_DISTRO}/${OS_RELEASE} ; \
	bash ${CMD_BUILD_DOCKERIMAGE} ;

clean_dockerimage_ubuntu_disco:
	@export OS_DISTRO=ubuntu ; \
	export OS_RELEASE=disco ; \
	make clean_dockerimage ;

clean_dockerimage:
	@echo "Cleaning ${OS_DISTRO} ${OS_RELEASE} Dockerimage ..." ; \
	cd osv/${OS_DISTRO}/${OS_RELEASE} ; \
	bash ${CMD_CLEAN_DOCKERIMAGE}
