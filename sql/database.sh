#!/bin/bash

set -xe

echo 'DROP DATABASE IF EXISTS `kemal-blog`' | mysql -uroot
echo 'CREATE DATABASE `kemal-blog`'         | mysql -uroot

mysql -uroot kemal-blog < table.sql
