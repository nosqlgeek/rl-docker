FROM ubuntu:xenial

ARG installer_file=redislabs-5.2.0.tar

ENV IS_CONTAINERIZED=1

RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y lsb-core less curl sudo net-tools logrotate avahi-daemon libnss-mdns
RUN apt-get update && apt-get install -y libboost-program-options1.58.0 libboost-serialization1.58.0 libcurl3 iptables python2.7 iputils-ping
# Remove after finishing debug
RUN apt-get update && apt-get install -y vim

# Will also extract the tarball
ADD ${installer_file} /opt
COPY install.conf /opt
WORKDIR /opt

COPY start.sh /opt
COPY container_hacks.sh /opt
RUN chmod +x /opt/start.sh /opt/container_hacks.sh

EXPOSE 53 5353 8001 8070 8080 8443 9443 10000-19999

CMD ["/bin/bash"]
