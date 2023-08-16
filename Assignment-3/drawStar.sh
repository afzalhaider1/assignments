#! /bin/bash
size=$1
type=$2

if [[ $type == "t1" ]]; then
    for ((i=1; i<=size; i++))
    do
        for ((j=size; j>i; j--))
        do
            echo -n " "
        done
        for ((k=1; k<=i; k++))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t2" ]]; then
    for ((i=1; i<=size; i++))
    do
        for ((j=1; j<=i; j++))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t3" ]]; then
    for ((i=1; i<=size; i++))
    do
        for ((j=size; j>i; j--))
        do
            echo -n " "
        done
        for ((k=1; k<=(2*i-1); k++))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t4" ]]; then
    for ((i=size; i>=1; i--))
    do
        for ((j=1; j<=i; j++))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t5" ]]; then
    for ((i=1; i<=size; i++))
    do
        for ((j=1; j<i; j++))
        do
            echo -n " "
        done
        for ((k=size; k>=i; k--))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t6" ]]; then
    for ((i=size; i>=1; i--))
    do
        for ((j=size; j>i; j--))
        do
            echo -n " "
        done
        for ((k=1; k<=(2*i-1); k++))
        do
            echo -n "*"
        done
        echo ""
    done
elif [[ $type == "t7" ]]; then
    for ((i=1; i<=size; i++))
    do
        for ((j=size; j>i; j--))
        do
            echo -n " "
        done
        for ((k=1; k<=(2*i-1); k++))
        do
            echo -n "*"
        done
        echo ""
    done
    for ((i=size-1; i>=1; i--))
    do
        for ((j=size; j>i; j--))
        do
            echo -n " "
        done
        for ((k=1; k<=(2*i-1); k++))
        do
            echo -n "*"
        done
        echo ""
    done
else
    echo "Invalid type. Please use type t1, t2, t3, t4, t5, t6, t7"
fi
