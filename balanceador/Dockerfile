FROM rockylinux:8

RUN yum install -y httpd \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY apache.conf /etc/httpd/conf.d/balanceador.conf

CMD ["httpd", "-DFOREGROUND"]
