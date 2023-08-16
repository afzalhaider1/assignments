#!/bin/bash

if [ "$#" -lt 3 ]; then
  echo "Invalid command use template_file variable=value variable=value...]"
  exit 1
fi

template_file=$1

echo "{{fname}} is trainer of {{topic}}" > $template_file
template_content=$(cat "$template_file")

for ((i = 2; i <= $#; i++)); do
  var_name=$(echo "${!i}" | cut -d '=' -f 1)
  var_value=$(echo "${!i}" | cut -d '=' -f 2)
  template_content=$(echo "$template_content" | sed "s/{{$var_name}}/$var_value/g")
done

echo "$template_content"
