FROM debian

ENV apr_version=1.7.0 apr_util_version=1.6.1 apache_version=2.4.46

WORKDIR usr/src/apache

EXPOSE 80 443

RUN apt-get update && \
  # install necessary Debian packages
  apt-get install -y build-essential curl git wget gawk libssl-dev libexpat1-dev libpcre3-dev libxml2-dev libyajl-dev ruby ssl-cert zlibc zlib1g-dev && \
  # download, unpack, configure compiler, and compile Apache web server and libraries
  wget https://www-eu.apache.org/dist/apr/apr-${apr_version}.tar.bz2 && tar -xvjf apr-${apr_version}.tar.bz2 && rm apr-${apr_version}.tar.bz2 && mv apr-${apr_version}/ apr/ && cd apr && \
  ./configure --prefix=/usr/local/apr && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist/apr/apr-util-${apr_util_version}.tar.bz2 && tar -xvjf apr-util-${apr_util_version}.tar.bz2 && rm apr-util-${apr_util_version}.tar.bz2 && mv apr-util-${apr_util_version}/ apr-util/ && cd apr-util && \
  ./configure --prefix=/usr/local/apr --with-apr=/usr/local/apr && \
  make && make install && cd /usr/src/apache && \
  wget https://www-eu.apache.org/dist//httpd/httpd-${apache_version}.tar.bz2 && tar -xvjf httpd-${apache_version}.tar.bz2 && rm httpd-${apache_version}.tar.bz2 && mv httpd-${apache_version}/ httpd/ && cd httpd && \
  ./configure --prefix=/opt/apache-${apache_version} --with-apr=/usr/local/apr/bin/apr-1-config \
    --with-apr-util=/usr/local/apr/bin/apu-1-config \
    --enable-mpms-shared=event \
    --enable-mods-shared=all \
    --enable-nonportable-atomics=yes && \
  make && make install && \
  # softlink apache
  ln -s /opt/apache-${apache_version} /apache

WORKDIR /apache

# download nikto GitHub repo as nikto Debian package is not free 
RUN git clone https://github.com/sullo/nikto && \
  # append apache bin and nikto program path to PATH environment variable 
  export PATH=$PATH:/apache/bin:/apache/nikto/program

COPY httpd.conf /apache/conf/httpd.conf

# run with daemon off as a single process in foreground
CMD [ "httpd", "-X" ] 