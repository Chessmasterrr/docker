FROM chessmasterrr/ubuntu:latest

# install dependencies:
#    software-properties-common for add-apt-repository command
#    iproute2 for ip command (used from wireguard in wg-quick)
RUN apt-get update && apt-get install -y \
		software-properties-common iproute2 \
	&& add-apt-repository ppa:wireguard/wireguard \
	&& apt-get update && apt-get install -y \
		wireguard \
	&& rm -rf /var/lib/apt/lists/*

# start wireguard
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
