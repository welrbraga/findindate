#!/bin/bash

# Prepara os argumentos para o comando find localizar arquivos dentro de um dado intervalo de datas

# Wbraga - 2018-11-27

#Versão atual do script. Altere-a sempre que precisar identificar uma
#nova versão da ferramenta
VERSION="2020.03"

#Configura o find para localizar arquivos dentre duas datas
between() {
  BEFOREFILE=$(mktemp --suffix .B.$USER)
  AFTERFILE=$(mktemp --suffix .A.$USER)
  touch -t "$1" "$AFTERFILE"
  touch -t "$2" "$BEFOREFILE"

  echo -newer "$AFTERFILE" -and \! -newer "$BEFOREFILE"
}

#Configura o find para localizar arquivos antes da data informada
before() {
  BEFOREFILE=$(mktemp --suffix .B.$USER)
  touch -t "$1" "$BEFOREFILE"

  echo \! -newer "$BEFOREFILE"
}

#Configura o find para localizar arquivos apos a data informada
after() {
  AFTERFILE=$(mktemp --suffix .A.$USER)
  touch -t "$1" "$AFTERFILE"

  echo -newer "$AFTERFILE"
}

#Valida a data passada a ser usada na funcao between()
checkdate() {
  case $MONTH in # Determina se é mes de 30 ou 31 dias
  01 | 03 | 05 | 07 | 08 | 10 | 12)
    lastday=31
    ;;
  04 | 06 | 09 | 11)
    lastday=30
    ;;
  02)
    lastday=28
    if ((${YEAR} % 4 == 0)) &&
      ((((${YEAR} % 100 != 0)) || ((${YEAR} % 400 == 0)))); then
      lastday=29
    fi #Determina se e ano bisexto
    ;;
  esac

  if (($informyear == 1)) && (($informmonth == 1)); then
    DATA1=$(date +${YEAR}${MONTH}010000)
    DATA2=$(date +${YEAR}${MONTH}${lastday}2359.59)
  fi
  if (($informyear == 1)) && (($informmonth == 0)); then
    DATA1=$(date +${YEAR}01010000)
    DATA2=$(date +${YEAR}12312359.59)
  fi
  if (($informyear == 0)) && (($informmonth == 1)); then
    YEAR=$(date +%Y)
    DATA1=$(date +${YEAR}${MONTH}010000)
    DATA2=$(date +${YEAR}${MONTH}${lastday}2359.59)
  fi
}

help() {
  echo "-false"
  cat <<EOF >&2
    Find In Date - Auxilia na localização de arquivos por data usando o GNU Find

    --after, -a [[CC]YY]MMDDhhmm[.ss]
    --before, -b [[CC]YY]MMDDhhmm[.ss]
      Arquivos modificados antes ou após a data/hora informada.

      * A data é informada no mesmo formato do comando "touch -t"

   --between, -w [[CC]YY]MMDDhhmm[.ss] [[CC]YY]MMDDhhmm[.ss]
     Arquivos modificados dentro do intervalo de tempo informado.

     * A data é informada no mesmo formato do comando "touch -t"

    --today , -t
      Arquivos modificados hoje

    --yesterday, -y
      Arquivos modificados ontem

    --inmonth, -m [01-12]
      Arquivos modificados no mês informado.

      * Informe o número do mês com 2 digitos.

      * Este parâmetro pode ser usado em conjunto com o --inyear para limitar ao
      mês de determinado ano.

    --inyear, -Y [ANO]
      Arquivos modificados no ano informado.

      * Informe o número do ano com 4 digitos.

      * Este parâmetro pode ser usado em conjunto com o --inmonth para limitar ao
      mês de determinado ano.

    --install
      Instala o script em um diretório visivel pela variavel PATH para que o script
      fique disponível a todos os usuarios do sistema.

    --help, -h
      Mostra esta ajuda

    ex.:
      find /var/log -type f \`findindate --today\` -ls
      find /var/log -type f \`findindate --yesterday\` -ls
      find /var/log -type f \`findindate --inmonth 05\` -ls
      find /var/log -type f \`findindate --inyear 2018\` -ls
      find /var/log -type f \`findindate --inyear 2016 --inmonth 02\` -ls
      find /var/log -type f \`findindate --before 201705010000\` -ls
      find /var/log -type f \`findindate --after 201705010000\` -ls

findindate - v. $VERSION
2020 (C) - Welington R Braga
EOF

}

YEAR=0
MONTH=0
DATA1=0
DATA2=0
informmonth=0
informyear=0

while [ "$1" ]; do

  case "$1" in

  "--between" | "-w")

    shift
    DATA1=$1
    shift
    DATA2=$1
    between $DATA1 $DATA2

    ;;

  "--before" | "-b")

    shift
    DATA1=$1
    before $DATA1

    ;;

  "--after" | "-a")

    shift
    DATA1=$1
    after $DATA1

    ;;

  "--today" | "-t")

    DATA1=$(date +%Y%m%d0000)
    after $DATA1

    ;;

  "--yesterday" | "-y")

    DATA1=$(date -d yesterday +%Y%m%d0000)
    DATA2=$(date -d yesterday +%Y%m%d2359.59)
    between $DATA1 $DATA2

    ;;

  "--inmonth" | "-m")
    informmonth=1
    shift
    MONTH=$1
    checkdate
    #Chamada ao termino do loop #between $DATA1 $DATA2;

    ;;

  "--inyear" | "-Y")
    informyear=1
    shift
    YEAR=$1
    checkdate
    #Chamada ao termino do loop #between $DATA1 $DATA2;

    ;;

  "--help" | "-h")

    help
    exit 1

    ;;

  "--version" | "-v")

    echo "findindate - v. $VERSION"
    exit 1

    ;;

  "--teste-me")
    echo "Janeiro - 2001"
    $0 --inyear 2001 --inmonth 01
    ls -lh /tmp/*date
    echo
    echo "Fevereiro - 2002"
    $0 --inmonth 02 --inyear 2002
    ls -lh /tmp/*date
    echo
    echo "Março - deste ano"
    $0 --inmonth 03
    ls -lh /tmp/*date
    echo
    echo "Todo ano - 2004"
    $0 --inyear 2004
    ls -lh /tmp/*date
    echo
    echo "Ontem"
    $0 --yesterday
    ls -lh /tmp/*date
    echo
    echo "Hoje"
    $0 --today
    ls -lh /tmp/*date

    exit 0
    ;;
  "--install")
    if [ "$USER" != "root" ]; then
      echo "ERRO: A instalação deve ser feita pelo usuario root" >&2
      exit 1
    fi
    FILE=$(which findindate)
    [ -f "$FILE" ] && rm "$FILE"
    NEWFILE="/usr/local/bin/findindate"
    cp "$0" "$NEWFILE"
    chmod 0755 "$NEWFILE"
    if [ -x "$NEWFILE" ]; then
      echo "Instalado em $NEWFILE"
    else
      echo "Ocorreu um erro ao instalar a ferramenta"
    fi
    ;;
  "--uninstall")
    if [ "$USER" != "root" ]; then
      echo "ERRO: A desinstalação deve ser feita pelo usuario root" >&2
      exit 1
    fi
    FILE=$(which findindate)
    if [ -f "$FILE" ]; then
      rm "$FILE"
      echo "Removido de $FILE"
    else
      echo "Ocorreu um erro ao remover a ferramenta"
    fi
    ;;
  esac
  shift

done

if (($informyear == 1)) || (($informmonth == 1)); then
  between $DATA1 $DATA2
fi

exit 0
