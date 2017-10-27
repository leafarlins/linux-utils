#!/bin/bash

# Recebe os segundos a expandir e o nome do arquivo
ARQ=$1
SEG=$2
> $ARQ.2

while read line; do
  if [[ $line =~ ^[0-9]{2}:[0-5][0-9]:[0-5][0-9] ]]; then
    echo "Linha valida: $line"
    HORAF=`echo $line | grep -Po "\-\-\> \K[0-6][0-9]:[0-6][0-9]:[0-6][0-9]"`
    SEGF=`echo $HORAF |cut -d':' -f3`
    SEGF="${SEGF#0}"
    SEGF2=$(($SEGF+2))
    if [ $SEGF2 -ge 60 ]
      then SEGF2=59
    fi
    [ $SEGF2 -le 9 ] && SEGF2="0$SEGF2"
    HORAF2=`echo $HORAF | sed "s/:$SEGF$/:$SEGF2/"`
    line=`echo $line | sed "s/$HORAF/$HORAF2/"`
    echo "Nova linha:   $line"
  fi
  echo $line >> $ARQ.2
done < $ARQ
