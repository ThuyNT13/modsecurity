FROM debian:stable-slim

ENV APR_VERSION=1.7.0 APR_UTIL_VERSION=1.6.1 APACHE_VERSION=2.4.46

WORKDIR /usr/src/apache

EXPOSE 80

RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
  # install essential packages
  build-essential curl git wget \ 
  # install application dependencies
  gawk libssl-dev libexpat1-dev libpcre3-dev libxml2-dev libyajl-dev ruby ssl-cert zlibc zlib1g-dev && \
  # clean out .deb installer files cached in /var/cache/apt/archives/
  apt-get clean && \
  # clear out package lists generated after every apt-get update; unnecessary after installed
  rm -rf /var/lib/apt/lists/* && \
  # remove any other temp files
  rm -rf /tmp/* /var/tmp/* && \
  # uncomment to truncate log file to zero-length - empty content do not delete file
  # truncate -s 0 /var/log/*log && \ 
  # download, unpack, configure compiler, and compile Apache web server and libraries
  wget https://www-eu.apache.org/dist/apr/apr-${APR_VERSION}.tar.bz2 && tar -xvjf apr-${APR_VERSION}.tar.bz2 && rm apr-${APR_VERSION}.tar.bz2 && mv apr-${APR_VERSION}/ apr/ && cd apr && \
  ./configure --prefix=/usr/local/apr && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist/apr/apr-util-${APR_UTIL_VERSION}.tar.bz2 && tar -xvjf apr-util-${APR_UTIL_VERSION}.tar.bz2 && rm apr-util-${APR_UTIL_VERSION}.tar.bz2 && mv apr-util-${APR_UTIL_VERSION}/ apr-util/ && cd apr-util && \
  ./configure --prefix=/usr/local/apr --with-apr=/usr/local/apr && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist//httpd/httpd-${APACHE_VERSION}.tar.bz2 && tar -xvjf httpd-${APACHE_VERSION}.tar.bz2 && rm httpd-${APACHE_VERSION}.tar.bz2 && mv httpd-${APACHE_VERSION}/ httpd/ && cd httpd && \
  ./configure --prefix=/opt/apache-${APACHE_VERSION} \
    --with-apr=/usr/local/apr/bin/apr-1-config \
    --with-apr-util=/usr/local/apr/bin/apu-1-config \
    --enable-mpms-shared=event \
    --enable-mods-shared=all \
    --enable-nonportable-atomics=yes && \
  make && make install && \
  # softlink apache
  ln -s /opt/apache-${APACHE_VERSION} /apache

# download nikto GitHub repo as nikto Debian package is not free 
RUN git clone https://github.com/sullo/nikto

# append apache bin and nikto program path to PATH environment variable 
ENV PATH $PATH:/apache/bin:/usr/src/apache/nikto/program

# run as a single process in foreground with daemon off
CMD [ "httpd", "-X" ] 