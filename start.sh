#!/bin/bash
mkdir -p /run/php-fpm
php-fpm &
httpd -DFOREGROUND
