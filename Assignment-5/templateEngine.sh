#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Invalid command use template_file variable=value variable=value...]"
  exit 1
fi

template_file=$1
echo "{{fname}} is trainer of {{topic}}" > $template_file
template_content=$(cat "$template_file")

shift
while [ "$#" -gt 0 ]; do
	var_name=$(echo "$1" | cut -d '=' -f 1)
	var_value=$(echo "$1" | cut -d '=' -f 2)

  template_content=$(echo "$template_content" | sed "s/{{$var_name}}/$var_value/g")

  shift 
done

echo "$template_content"

