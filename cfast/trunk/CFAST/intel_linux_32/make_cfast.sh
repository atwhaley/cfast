#!/bin/bash
platform=ia32
dir=`pwd`
target=${dir##*/}

source $IFORT_COMPILER/bin/ifortvars.sh $platform

echo Building $target
make VPATH="../Source:../Include" -f ../makefile $target