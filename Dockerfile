FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y -q install software-properties-common tini xtail
RUN apt-add-repository ppa:iconnor/zoneminder-1.36 && \
    apt-get update && \
    apt install -y -q zoneminder
RUN ln -s /var/cache/zoneminder/cache /usr/share/zoneminder/www/ && \
    cp -r /usr/share/zoneminder/www/fonts /usr/share/zoneminder/www/skins/classic/css/
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ADD geofront-zm.conf /etc/zm/conf.d/geofront-zm.conf
RUN rm -f /etc/apache2/sites-enabled/000-default.conf
ADD apache-zoneminder.conf /etc/apache2/sites-enabled/zoneminder.conf
RUN mkdir /var/log/zoneminder && chown www-data /var/log/zoneminder && chmod 644 /var/log/zoneminder
ENTRYPOINT [ "/usr/bin/tini", "-s", "--", "/entrypoint.sh" ]
