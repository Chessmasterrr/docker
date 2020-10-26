FROM ubuntu:latest

# install dependencies:
#    iproute2 for ip command (used from wireguard in wg-quick)
RUN apt-get update && apt-get install -y \
		iproute2 wireguard \
	&& rm -rf /var/lib/apt/lists/*

# start wireguard
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
