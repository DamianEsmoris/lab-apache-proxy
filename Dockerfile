FROM rockylinux:8

RUN yum install -y epel-release \
    && yum install -y httpd php php-cli php-common \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY apache-conf.d/*.conf /etc/httpd/conf.d/
COPY index.php /var/www/html/
COPY --chmod=500 start.sh /start.sh

CMD ["/start.sh"]
