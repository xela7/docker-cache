
build:
	docker build -t docker_cache_server_image github.com/GlobAllomeTree/docker-cache

build-local:
	docker build -t docker_cache_server_image .

run: create-cache-dirs clean clean-bash
	docker run -d -name docker_cache_server -p 8095:8095 -p 8096:8096 -v /opt/cache:/home/docker/cache docker_cache_server_image

clear-cache: delete-cache-dir create-cache-dirs

create-cache-dirs:
	sudo mkdir -p /opt
	sudo mkdir -p /opt/cache
	sudo mkdir -p /opt/cache/pip
	sudo mkdir -p /opt/cache/apt

delete-cache-dir:
	sudo rm -rf /opt/cache/

clean: stop
	-@docker rm docker_cache_server 2>/dev/null || true

stop:
	-@docker stop docker_cache_server 2>/dev/null || true


###################################### DEBUG ################################

run-bash: stop clean-bash
	docker run -i -t -name docker_cache_server_bash -p 8095:8095 -v /opt/cache:/home/docker/cache docker_cache_server_image /bin/bash

stop-bash:
	-@docker stop docker_cache_server_bash 2>/dev/null || true

clean-bash: stop-bash
	-@docker rm docker_cache_server_bash 2>/dev/null || true

logs:
	docker logs docker_cache_server


###################################### TEST ################################

test-install-django: 
	sudo pip install -i http://127.0.0.1:8095/simple django

remove-django:
	sudo pip uninstall django

#test with an unverified package (does not get cached locally)
test-install-pypdf: 
	sudo pip install -i http://127.0.0.1:8095/simple pyPDF --allow-external pyPDF --allow-unverified pyPDF

remove-pypdf:
	sudo pip uninstall pyPDF

