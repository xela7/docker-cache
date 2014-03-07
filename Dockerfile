FROM ubuntu:precise

MAINTAINER Bit Bamboo, LLC "alext@bitbamboo.com"

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-setuptools python-pip supervisor git apt-cacher-ng

#http://pypicache.readthedocs.org/en/latest/
RUN cd /tmp &&\
	pip install -e git+https://bitbucket.org/micktwomey/pypicache.git#egg=pypicache &&\
	pip install -r /tmp/src/pypicache/requirements.txt

ADD . /home/docker/code/ 
RUN ln -s /home/docker/code/server/supervisor.conf /etc/supervisor/conf.d/
RUN mkdir /home/docker/cache/

CMD ["/bin/bash", "/home/docker/code/server/startup.sh"]