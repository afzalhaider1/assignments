#!/bin/bash

while getopts "lb:d:mr1:2:" options; do
  case "${options}" in
    l)
      git branch
      ;;
    b)
      git branch $OPTARG
      ;;
    d)
      git branch -d $OPTARG
      ;;
    m)
      branch1=${OPTARG}
      ;;
    r)
      branch1=${OPTARG}
      ;;
    1)
      branch1=${OPTARG}
      ;;
    2)
      branch2=${OPTARG}
      ;;
    ?)
      echo "Invalid option: Use -l, -b, -d, -m, -r"
      exit 1
      ;;  
   esac
done

if [ "$1" == "-m" ]; then
  git checkout $branch2
  git merge $branch1
elif [ "$1" == "-r" ]; then
  git checkout $branch2
  git rebase $branch1
else
  echo "Invalid option. Please use -m or -r for merge or rebase."
  exit 1
fi
