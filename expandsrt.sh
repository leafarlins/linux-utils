#!/bin/bash

# Soma segundos na hora
function somahora() {
    HORA=$1
    SEGUNDOS=$2
    HOR=`echo $HORA |cut -d':' -f1`
    MIN=`echo $HORA |cut -d':' -f2`
    SEG=`echo $HORA |cut -d':' -f3`
    SEG="${SEG#0}"
    SEG=$(($SEG + $SEGUNDOS))
    if [ $SEG -ge 60 ]
      then SEG=$(($SEG-60))
      MIN="${MIN#0}"
      MIN=$(($MIN+1))
      if [ $MIN -ge 60 ]
        then MIN=$(($MIN-60))
        HOR="${HOR#0}"
        HOR=$(($HOR+1))
        [ $HOR -le 9 ] && HOR="0$HOR"
      fi
      [ $MIN -le 9 ] && MIN="0$MIN"
    fi
    [ $SEG -le 9 ] && SEG="0$SEG"
    
    echo "$HOR:$MIN:$SEG"
}

# Retorna segundos de diferenca $1-$2
function diffhora() {
    HORA1=$1
    HORA2=$2
    HOR1=`echo $HORA1 |cut -d':' -f1`
    MIN1=`echo $HORA1 |cut -d':' -f2`
    SEG1=`echo $HORA1 |cut -d':' -f3`
    HOR2=`echo $HORA2 |cut -d':' -f1`
    MIN2=`echo $HORA2 |cut -d':' -f2`
    SEG2=`echo $HORA2 |cut -d':' -f3`
    DIFF=$(((${HOR1#0} - ${HOR2#0})*3600 + (${MIN1#0} - ${MIN2#0})*60 + ${SEG1#0} - ${SEG2#0} ))
    echo $DIFF
    
}

# Recebe os segundos a expandir e o nome do arquivo
ARQ="$1"
SEGA=$2
HORALAST=''
> $ARQ.2

while read line; do
  if [[ $line =~ ^[0-9]{2}:[0-5][0-9]:[0-5][0-9] ]]; then
    echo "Linha valida: $line"
    HORAI=`echo $line | grep -Po "^[0-6][0-9]:[0-6][0-9]:[0-6][0-9]"`
    HORAIT=`echo $line | grep -Po "^[0-6][0-9]:[0-6][0-9]:[0-6][0-9],[0-9]{3}"`
    HORAF=`echo $line | grep -Po "\-\-\> \K[0-6][0-9]:[0-6][0-9]:[0-6][0-9]"`
    HORAF2=`somahora $HORAF $SEGA`
    line=`echo $line | sed "s/$HORAF/$HORAF2/"`
    
    if [ -n "$HORALAST" ]; then
      if [ `diffhora $HORAI $HORALAST` -le 0 ]; then
        sed -i -E "s/--> $HORALAST,[0-9]{3}/--> $HORAIT/" "$ARQ.2"
        if [ $? -ne 0 ]; then "Erro na troca"
        else echo "Troca: $HORALAST/$HORAIT"
        fi
    fi; fi
    HORALAST=$HORAF2
    
    echo "Nova linha:   $line"
  fi
  # else ... grep -P "(:?^[0-9]+$|^$)" para definir texto
  echo $line >> "$ARQ.2"
done < "$ARQ"



