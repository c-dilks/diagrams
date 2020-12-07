#!/bin/bash
# convert latex file to png
# dependencies: 
# - pdflatex
# - ImageMagick (for convert command)

if [ $# -lt 1 ]; then
  echo "USAGE $0 [tex file] [density(default=300)]"
  exit
fi

texfile=$1
pdffile=$(echo $texfile | sed 's/\.tex$/.pdf/g')
pngfile=$(echo $texfile | sed 's/\.tex$/.png/g')

density=300
if [ $# -gt 1 ]; then density=$2; fi

pdflatex -interaction=nonstopmode $1

convert \
-trim -border 0 \
-bordercolor white +adjoin \
-density ${density}x${density} +antialias \
-transparent white \
$pdffile $pngfile
