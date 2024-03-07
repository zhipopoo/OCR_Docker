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
xvfb-run java -jar app.jar -Xms1024m -Xmx2048m
