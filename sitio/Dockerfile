FROM rockylinux:8

RUN yum install -y httpd php \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY index.php /var/www/html/
COPY --chmod=500 start.sh /start.sh

CMD ["/start.sh"]
