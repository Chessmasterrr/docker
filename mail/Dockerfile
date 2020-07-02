FROM ubuntu:20.04

# install needed packages:
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		dovecot-core \
		dovecot-imapd \
		dovecot-lmtpd \
		dovecot-mysql \
		dovecot-sieve \
		dovecot-managesieved \
		postfix \
		postfix-mysql \
		rspamd \
		unbound \
		redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY mailserver.sh .

RUN set -xe \
    && chmod +x /mailserver.sh \
    && adduser --disabled-login --disabled-password --home /var/vmail vmail

EXPOSE 143
EXPOSE 587
EXPOSE 4190

CMD /mailserver.sh
