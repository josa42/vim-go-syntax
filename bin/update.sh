#!/bin/bash

run() {
  files=(
    'LICENSE'
    'autoload/go/config.vim'
    'syntax/go.vim'
    'syntax/gomod.vim'
  )

  echo "Download files"
  for f in ${files[@]}; do
    echo "> $f" >&2
    curl -sS https://raw.githubusercontent.com/fatih/vim-go/master/$f \
      > $f
  done

  echo ""
  echo "Filter config.vim"

  filterConfig > autoload/go/config.vim.tmp
  mv autoload/go/config.vim{.tmp,}
}

filterConfig() {
  includeFn=0
  IFS=$'\n'; for l in $(cat autoload/go/config.vim); do
    case $l in
      function!*)
        fn=$(echo $l | sed 's/^.* \(go#.*\)(.*/\1/')
        if [[ "$(cat syntax/*.vim | grep $fn)" != "" ]]; then
          echo "> $fn()" >&2
          includeFn=1
        fi
        ;;
      endfunction*)
        [ $includeFn -eq 1 ] && echo $l && echo ""
        includeFn=0
        ;;
    esac

    [ $includeFn -eq 1 ] && echo $l
  done
}


run $@



