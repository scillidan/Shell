#!/bin/bash
# Source: https://brontosaurusrex.github.io/2019/08/12/Halftone,-Imagemagick

set -e

magick "$1" -level 0x70% \
  -set option:distort:viewport '%wx%h+0+0' \
  -colorspace CMYK -separate null: \
  \( -size 2x2 xc: \( +clone -negate \) \
  +append \( +clone -negate \) -append \) \
  -virtual-pixel tile -filter gaussian \
  \( +clone -distort SRT 60 \) +swap \
  \( +clone -distort SRT 30 \) +swap \
  \( +clone -distort SRT 45 \) +swap \
  \( +clone -distort SRT 0 \)  +swap +delete \
  -compose Overlay -layers composite \
  -set colorspace CMYK -combine -colorspace RGB \
  _cmyk_halftone.png