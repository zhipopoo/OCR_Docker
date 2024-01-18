#!/bin/bash
mysql -uroot -p <<EOF

CREATE DATABASE ocr;
use ocr;
source ocr.sql;

exit
EOF