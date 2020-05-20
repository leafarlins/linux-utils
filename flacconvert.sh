#!/bin/bash

# Necessario instalar pacotes flac e lame

while [ "$1" != '' ]; do
  case $1 in
    -pre | -p ) shift
      PRENAME="$1 "
  ;;
    -suf | -s ) shift
      SUFNAME=" $1"
  ;;
     -b ) shift
      BIRATE="-b $1"
  ;;
     -h | --help)
      echo "Uso: $0
Utilize dentro do diretório com arquivos .flac

-pre     Add prename to output file
-suf     Add sufix to output file
-b       Configure birate of mp3 file (128|160|192|320)
      "
      exit 0
  ;;
    * ) echo "Parametro invalido."
  esac
  shift
done

for a in *.flac; do
  # give output correct extension
  OUTF="${a[@]/%flac/mp3}"
  OUTF="$PRENAME$OUTF$SUFNAME"

  # get the tags
  ARTIST=$(metaflac "$a" --show-tag=ARTIST | sed s/.*=//g)
  TITLE=$(metaflac "$a" --show-tag=TITLE | sed s/.*=//g)
  ALBUM=$(metaflac "$a" --show-tag=ALBUM | sed s/.*=//g)
  GENRE=$(metaflac "$a" --show-tag=GENRE | sed s/.*=//g)
  TRACKNUMBER=$(metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g)
  DATE=$(metaflac "$a" --show-tag=DATE | sed s/.*=//g)

  # stream flac into the lame encoder
  flac -c -d "$a" | lame -V0 --add-id3v2 --pad-id3v2 --ignore-tag-errors $BIRATE \
    --ta "$ARTIST" --tt "$TITLE" --tl "$ALBUM"  --tg "${GENRE:-12}" \
    --tn "${TRACKNUMBER:-0}" --ty "$DATE" - "$OUTF"
done
