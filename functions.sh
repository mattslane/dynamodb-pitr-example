#!/usr/bin/env bash

FILE_NAME="$(pwd)/terraform/main.tf"

get_resource_name() {
    RESOURCE_NAME=$(sed -En 's/.*aws_dynamodb_table\"[[:space:]]\"([^\"]*).*/\1/p' "${FILE_NAME}")
    echo "Terraform dynamodb resource: ${RESOURCE_NAME}"
}

get_old_table_name() {
   OLD_TABLE_NAME=$(awk '/aws_dynamodb_table/,/name/ {
       names[$1]=$3 
   } END {
       for(n in names){
           if(n == "name"){
             print names[n]
           }
       }
   }'  < "$FILE_NAME" | tr -d \")
   echo "Will restore from $OLD_TABLE_NAME"
}

generate_updated_table_name() {
   table_number=$(echo "${OLD_TABLE_NAME}" | sed -En 's/.*-([[:digit:]])/\1/p')
   table_number=$((table_number + 1))
   last_char=${OLD_TABLE_NAME: -1}
   if [ "$last_char" -eq  "$last_char" ] 2>/dev/null; then
      :
   else
      table_number="-${table_number}"
   fi

   NEW_TABLE_NAME=$(echo "${OLD_TABLE_NAME}" | sed -En "s/[[:digit:]]*$/${table_number}/p")
   echo "New table name: ${NEW_TABLE_NAME}"
}
