#!/bin/bash

foma -e "read lexc ../apertium-uig.uig.lexc" -e "quit" | grep Root | sed 's/,/\n/g' | grep '[A-Z][a-z]\+' | grep -v 'Root' | grep -o '[0-9]\+$' | sed 's/$/+/g' | tr -d '\n' | sed 's/\+$//g' | calc -p
