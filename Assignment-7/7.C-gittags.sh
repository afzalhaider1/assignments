#!/bin/bash

while getopts "lt:d:" options; do
  case "${options}" in
    l)
      git tag
      ;;
    t)
      git tag $OPTARG
      ;;
    d)
      git tag -d $OPTARG
      ;;
    ?)
      echo "Invalid option: Use -l, -t, -d."
      exit 1
      ;;  
   esac
done
