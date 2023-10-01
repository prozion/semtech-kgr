#!/bin/bash

# Usage: sort.sh people.tree

sort.rkt --by-id a-z --pars-order "alt,name,bplace,start,bdate,end,ddate,job,place,hq,city,url,pub-url" --ignore-keys "a" /home/denis/projects/semtech_kgr/source/facts/$1
