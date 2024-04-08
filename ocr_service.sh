#!/bin/bash

service mysql restart

mysql <<EOF
DROP DATABASE IF EXISTS ocr;
CREATE DATABASE ocr;
use ocr;
source ocr.sql;

exit
EOF

ulimit -n 2000
xvfb-run java -Dsun.java2d.cmm=sun.java2d.cmm.kcms.KcmsServiceProvider -jar app.jar -Xms1024m -Xmx2048m
