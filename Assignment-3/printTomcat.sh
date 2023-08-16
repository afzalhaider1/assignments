#! /bin/bash

num=$1
   	if [[ "$num" =~ [^0-9] ]]; then
 		 echo "Error: Invalid input. Only numeric values are allowed."
 		 exit 1
	fi

	
	if (($num % 15 == 0)); then
    		echo "tomcat"
	elif (($num % 5 == 0)); then
   		echo "cat"
	elif (($num % 3 == 0)); then
    		echo "tom"
	else
    		echo "Number is not divisible by 3, 5 or 15."
	fi	
