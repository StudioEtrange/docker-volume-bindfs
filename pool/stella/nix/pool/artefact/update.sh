#!/usr/bin/env bash
_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# https://github.com/rudimeier/bash_ini_parser
update_bash_ini_parser() {
  rm -Rf "${_CURRENT_FILE_DIR}/bash_ini_parser"
  # NOTE do not use albfan fork which seems to have problem when evaluating value
  #git clone https://github.com/albfan/bash_ini_parser "${_CURRENT_FILE_DIR}/bash_ini_parser"
  echo "Using https://github.com/rudimeier/bash_ini_parser v0.4.2"
  git clone https://github.com/rudimeier/bash_ini_parser "${_CURRENT_FILE_DIR}/bash_ini_parser"
  cd "${_CURRENT_FILE_DIR}/bash_ini_parser"
  git checkout "v0.4.2"
  rm -Rf "${_CURRENT_FILE_DIR}/bash_ini_parser/.git"
}

# https://github.com/KittyKatt/screenFetch
update_screenFetch() {
  rm -Rf "${_CURRENT_FILE_DIR}/screenFetch"
  echo "Using https://github.com/KittyKatt/screenFetch"
  git clone https://github.com/KittyKatt/screenFetch "${_CURRENT_FILE_DIR}/screenFetch"
  rm -Rf "${_CURRENT_FILE_DIR}/screenFetch/.git"
}

# https://github.com/StudioEtrange/lddtree
update_lddtree() {
  rm -Rf "${_CURRENT_FILE_DIR}/lddtree"
  echo "Using StudioEtrange fork (https://github.com/StudioEtrange/lddtree) of original ncopa (https://github.com/ncopa/lddtree)"
  git clone https://github.com/StudioEtrange/lddtree "${_CURRENT_FILE_DIR}/lddtree"
  rm -Rf "${_CURRENT_FILE_DIR}/lddtree/.git"
}

# https://github.com/agriffis/pure-getopt
update_pure-getopt() {
  echo "TODO"
}

case $1 in
  bash_ini_parser )
    update_bash_ini_parser
    ;;
  pure-getopt )
    update_pure-getopt
    ;;
  screenFetch )
    update_screenFetch
    ;;
  lddtree )
    update_lddtree
    ;;
    * )
    echo "Usage : ${_CURRENT_FILE_DIR}/update.sh <bash_ini_parser|pure-getopt|screenFetch|lddtree>"
    ;;
esac
