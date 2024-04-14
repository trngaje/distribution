#!/bin/bash

#echo $1
romname=`basename $1`
#echo $romname
#echo "${romname%.*}"

advmame "${romname%.*}"
 
