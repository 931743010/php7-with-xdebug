#!/bin/bash

if [ ! -d download ]; then
	mkdir download
fi

cd download
XDEBUG_PKG=xdebug-2.4.0rc1.tgz

wget http://xdebug.org/files/$XDEBUG_PKG
tar xvzf $XDEBUG_PKG －C xdebug
cd xdebug

phpize7.0
./configure --enable-xdebug
make
make install