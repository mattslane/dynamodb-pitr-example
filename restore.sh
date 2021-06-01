#!/bin/bash

. functions.sh

get_old_table_name
generate_updated_table_name

aws dynamodb restore-table-to-point-in-time \
  --source-table-name "$OLD_TABLE_NAME" \
  --target-table-name "$NEW_TABLE_NAME"

aws dynamodb wait table-exists --table-name "$NEW_TARGET_NAME"

cd terraform 
terraform plan 2>/dev/null
if [ "$?" -gt 0 ]
then
    terraform init --backend-config backend.hcl
fi

terraform state rm aws_dynamodb_table.$RESOURCE_NAME
sed -i "s/$OLD_TABLE_NAME/$NEW_TABLE_NAME/g" main.tf
terraform import aws_dynamodb_table.bird_sightings "$NEW_TABLE_NAME"
terraform plan


