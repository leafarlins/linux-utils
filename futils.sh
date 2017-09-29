#!/bin/bash
# 
# Script: futils.sh
# Objetivo: reunir funcoes que podem ser uteis a outros scripts
#
# Autor: SITEC
# Data: 02/02/2017
#
# Esse script encontra-se versionado no git em
# https://git.pje.csjt.jus.br/infra/regional/tree/master/jira
#
# Execucao: Esse script recebe chamado de outros scripts:
# - backup_jira-data.sh
# - bkp_fs_git.sh
# 
# Versao 1.2
########################################################################

# Verifica a duracao de tempo entre um horario e outro (horamin HH:MM:SS HH:MM:SS)
function horamin() {
  H1=`echo $1 | cut -d':' -f1 `
  H2=`echo $2 | cut -d':' -f1 `
  M1=`echo $1 | cut -d':' -f2 `
  M2=`echo $2 | cut -d':' -f2 `
  S1=`echo $1 | cut -d':' -f3 `
  S2=`echo $2 | cut -d':' -f3 `

  # Retira o zero das horas e minutos menores que 10
  H1="${H1#0}"
  H2="${H2#0}"
  M1="${M1#0}"
  M2="${M2#0}"
  S1="${S1#0}"
  S2="${S2#0}"

  # Calcula a diferenca das horas
  DH=$(($H2 - $H1))
  DM=$(($M2 - $M1))
  DS=$(($S2 - $S1))
  if [ $DM -lt 0 ]; then
    DM=$(($DM + 60))
    DH=$(($DH - 1))
  fi
  if [ $DS -lt 0 ]; then
    DS=$(($DS + 60))
    DM=$(($DM - 1))
  fi
  DURACAO=$((60 * DH + DM))
  DURACAOS=$((60 * DM + DS))

  # Trata casos em que tempo fica negativo (vira o dia)
  if [ $DURACAO -lt 0 ]; then
    DURACAO=$(($DURACAO + 1440))
  fi
  
  # Caso tempo maior que 2, imprime
  if [ $DURACAO -ge 2 ]; then
     echo "$DURACAO minutos"
  elif [ $DURACAO -eq 1 ]; then
     DURACAOS=$(($DURACAOS - 60))
     echo "1 minuto e $DURACAOS segundos"
  else echo "$DURACAOS segundos"
  fi

}

# Retorna a duracao de tempo entre um horario e outro (horamin HH:MM:SS HH:MM:SS)
function durhora() {
  H1=`echo $1 | cut -d':' -f1 `
  H2=`echo $2 | cut -d':' -f1 `
  M1=`echo $1 | cut -d':' -f2 `
  M2=`echo $2 | cut -d':' -f2 `
  S1=`echo $1 | cut -d':' -f3 `
  S2=`echo $2 | cut -d':' -f3 `

  # Retira o zero das horas e minutos menores que 10
  H1="${H1#0}"
  H2="${H2#0}"
  M1="${M1#0}"
  M2="${M2#0}"
  S1="${S1#0}"
  S2="${S2#0}"
    
  # Calcula a diferenca das horas
  DH=$(($H2 - $H1))
  DM=$(($M2 - $M1))
  DS=$(($S2 - $S1))
  DIFS=$(($DH * 3600 + $DM * 60 + $DS))

  if [ $DS -lt 0 ]; then
    DS=$(($DS + 60))
    DM=$(($DM - 1))
  fi
  if [ $DM -lt 0 ]; then
    DM=$(($DM + 60))
    DH=$(($DH - 1))
  fi

  # Trata casos em que tempo fica negativo (vira o dia)
  if [ $DH -lt 0 ]; then
    DH=$(($DH + 24))
  fi
  if [ "x$3" == "xs" ]; then #Total em segundos
    echo "$DIFS"
  else printf "%02d:%02d'%02d\"\n" "$DH" "$DM" "$DS"
  fi

}
#durhora $1 $2
