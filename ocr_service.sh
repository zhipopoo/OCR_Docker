#!/bin/bash

ulimit -n 2000
xvfb-run java -jar app.jar -Xms1024m -Xmx2048m
