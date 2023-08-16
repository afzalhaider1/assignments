#!/bin/bash
while getopts "u:d:" opt; do
    case $opt in
        u)
            repo_url="$OPTARG"
            ;;
        d)
            days="$OPTARG"
            ;;
    esac
done
git clone "$repo_url"
repo_name=${repo_url%.git}
repo_name=${repo_name##*/}
cd "$repo_name"


echo "Date,Author Name,Author Email,Commit Hash,Commit Message" > commit_report.csv

git log --pretty=format:"%ad|%an|%ae|%H|%s" --since="$days days ago" > temp
cat temp
cat temp | tr ',' ' &&' | tr '|' ',' > temp2
cat temp2 >> commit_report.csv
rm temp temp2

