#!/bin/bash

action="$1"

case $action in

addlinetop)
     file=$2
     line=$3
      if [ -s "$file" ]; then
        if [ "$line" ]; then
            sed -i "1i\\$line" "$file"
        else
            echo "Line not provided."
        fi
    else
        echo "File not found."
    fi
    ;;
        
addlinebottom)		
     file=$2
     line=$3
      if [ -s "$file" ]; then
        if [ "$line" ]; then
            sed -i "\$a\\$line" "$file"
        else
            echo "Line not provided."
        fi
    else
        echo "File not found."
    fi
    ;;
    
addlineat)
     file=$2
     line_number=$3
     line=$4
      if [ -s "$file" ]; then
        if [ "$line_number" ] && [ "$line" ]; then
            sed -i "${line_number}i\\$line" "$file"
        else
            echo "Line not provided."
        fi
    else
        echo "File not found."
    fi
    ;;
    
updatefirstword)
      file=$2
      word1=$3
      word2=$4

    if [ -s "$file" ]; then
        if [ "$word1" ] && [ "$word2" ]; then
            sed -i "s/\b$word1\b/$word2/" "$file"
        else
            echo "Word1 or Word2 not provided."
        fi
    else
        echo "File not found."
    fi
     ;;
     
updateallwords)
      file=$2
      word1=$3
      word2=$4

    if [ -s "$file" ]; then
        if [ "$word1" ] && [ "$word2" ]; then
            sed -i "s/\b$word1\b/$word2/g" "$file"
        else
            echo "Word1 or Word2 not provided."
        fi
    else
        echo "File not found."
    fi
     ;;
     
insertword)
      file=$2
      word1=$3
      word2=$4
      word_to_insert=$5

    if [ -s "$file" ]; then
        if [ "$word1" ] && [ "$word2" ] && [ "$word_to_insert" ]; then
            sed -i "s/\b$word1\b \b$word2\b/$word1 $word_to_insert $word2/" "$file"
        else
            echo "Word1, Word2, or Word to be inserted not provided."
        fi
    else
        echo "File not found."
    fi
    ;;
     
deleteline)
    file=$2
    line=$3
    word=$4

    if [ -s "$file" ]; then
        if [ "$line" ]; then
            sed -i "${line}d" "$file"
        elif [ "$word" ]; then
            sed -i "/\b$word\b/d" "$file"
        else
            echo "Line number or word not provided."
        fi
    else
        echo "File not found."
    fi
    ;;
     
*)
         echo "Invalid action: Use action addlinetop, addlinebottom, addlineat, updatefirstword, updateallwords, insertword and deleteline"
        exit 1
     ;;
esac
