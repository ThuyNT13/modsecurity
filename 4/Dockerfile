ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

ENV APR_VERSION=1.7.0 APR_UTIL_VERSION=1.6.1 APACHE_VERSION=2.4.46

WORKDIR /usr/src/apache

EXPOSE 80 443

RUN apk update && apk add --no-cache \
  # install essential packages 
  build-base curl git net-tools wget \
  # install application dependencies 
  gawk libxml2-dev nikto ruby expat-dev pcre-dev openssl-dev yajl-dev ca-certificates zlib-dev && \
  # ERROR: unsatisfiable constraints:
  # libexpat1-dev libpcre3-dev libssl-dev libyajl-dev ssl-cert zlibc zlib1g-dev
  # download and unpack, configure compiler, and compile Apache web server and libraries
  wget https://www-eu.apache.org/dist/apr/apr-${APR_VERSION}.tar.bz2 && \
    tar -xvjf apr-${APR_VERSION}.tar.bz2 && \ 
    rm apr-${APR_VERSION}.tar.bz2 && \
    mv apr-${APR_VERSION}/ apr/ && cd apr && \
  ./configure --prefix=/usr/local/apr/ && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist/apr/apr-util-${APR_UTIL_VERSION}.tar.bz2 && \
    tar -xvjf apr-util-${APR_UTIL_VERSION}.tar.bz2 && \
    rm apr-util-${APR_UTIL_VERSION}.tar.bz2 && \
    mv apr-util-${APR_UTIL_VERSION}/ apr-util/ && cd apr-util && \
  ./configure --prefix=/usr/local/apr/ --with-apr=/usr/local/apr/ && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist//httpd/httpd-${APACHE_VERSION}.tar.bz2 && \
    tar -xvjf httpd-${APACHE_VERSION}.tar.bz2 && \
    rm httpd-${APACHE_VERSION}.tar.bz2 && \
    mv httpd-${APACHE_VERSION}/ httpd/ && cd httpd && \
  ./configure --prefix=/opt/apache-${APACHE_VERSION} \
    --with-apr=/usr/local/apr/bin/apr-1-config \
    --with-apr-util=/usr/local/apr/bin/apu-1-config \
    --enable-mpms-shared=event \
    --enable-mods-shared=all \
    --enable-nonportable-atomics=yes && \
  make && make install && \
  # softlink apache
  ln -s /opt/apache-${APACHE_VERSION} /apache

ENV PATH $PATH:/apache/bin

COPY httpd.conf /apache/conf/httpd.conf

# run as a single process in foreground with daemon off
CMD [ "httpd", "-X" ] 