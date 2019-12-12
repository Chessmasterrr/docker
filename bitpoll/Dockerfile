FROM python

### set values ###
ENV BITPOLL_URL https://github.com/fsinfuhh/Bitpoll

### Prepareration ###
RUN git clone $BITPOLL_URL \
  && cd Bitpoll \
  && apt-get update \
	&& apt-get install -y --no-install-recommends \
	   virtualenv \
     g++ \
     make \
     python3-psycopg2 \
     python3-ldap3 \
     gettext \
     gcc \
     python3-dev \
     libldap2-dev \
     libsasl2-dev \
	&& rm -rf /var/lib/apt/lists/* \
  && pip install -r requirements-production.txt \
  && pip install mysqlclient \
  && chown -R www-data:www-data /Bitpoll

USER www-data
WORKDIR /Bitpoll
EXPOSE 8000

CMD ./manage.py compilemessages \
  && ./manage.py collectstatic --noinput \
  && ./manage.py runserver 0.0.0.0:8000
