#!/usr/bin/env bash
export AWS_PAGER=""

set -o pipefail
set -o nounset
set -ex

. functions.sh

get_resource_name
get_old_table_name
generate_updated_table_name

latest_date=$( aws dynamodb  describe-continuous-backups \
   --table-name "${OLD_TABLE_NAME}" \
   --query 'ContinuousBackupsDescription.PointInTimeRecoveryDescription.LatestRestorableDateTime')

echo "Restoring Backup from ${latest_date}"

aws dynamodb restore-table-to-point-in-time \
  --source-table-name "${OLD_TABLE_NAME}" \
  --target-table-name "${NEW_TABLE_NAME}" \
  --use-latest-restorable-time 

aws dynamodb wait table-exists --table-name "${NEW_TABLE_NAME}"

cd terraform || exit

if ! terraform plan 2>/dev/null; then
    terraform init --backend-config backend.hcl
fi

terraform state rm "aws_dynamodb_table.${RESOURCE_NAME}"
sed -i.bak "s/${OLD_TABLE_NAME}/${NEW_TABLE_NAME}/g" main.tf
terraform import "aws_dynamodb_table.${RESOURCE_NAME}" "${NEW_TABLE_NAME}"
terraform plan
