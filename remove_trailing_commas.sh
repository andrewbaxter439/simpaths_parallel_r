#!/usr/bin/env bash

find . -type f -name '*.csv' -print0 | parallel -q0 -P 25 sed -i 's/,[[:blank:]]*$//g'
