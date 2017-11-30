FROM redis:3.2-alpine

ENV HOME /root

RUN apk update && apk upgrade && apk --update add \
    bash gcc make g++ linux-headers \
    ruby ruby-irb ruby-rake ruby-io-console ruby-bigdecimal ruby-json ruby-bundler \
    gettext libintl supervisor \
    && \
    echo 'gem: --no-document' > /etc/gemrc && \
    gem install redis

RUN gem install redis

ARG redis_version=3.2.9
RUN wget -qO redis.tar.gz http://download.redis.io/releases/redis-${redis_version}.tar.gz \
    && tar xfz redis.tar.gz -C / \
    && mv /redis-$redis_version /redis
RUN (cd /redis && make)

RUN mkdir /redis-conf && mkdir /redis-data && mkdir /var/log/supervisor
COPY ./docker-data/redis-cluster.tmpl /redis-conf/redis-cluster.tmpl
COPY ./docker-data/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./docker-data/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 30001 30002 30003 30004 30005 30006

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]
