#!/bin/bash

service mysql start
service nginx start
/usr/sbin/php-fpm7.0 -F