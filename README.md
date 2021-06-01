# Dynamodb PITR Example

## Setup Backend

Log into Scully and get command line tokens

```
cd backend
terraform init
terraform apply
cd ..
```

## Create table

```sh
cd terraform
terraform init --backend-config backend.hcl
```

Apply:
```sh
terraform apply
cd .. 
```

## Populate table (optional)

```sh
cd populate
python3 -m venv env
source env/bin/activate
pip3 install -r requirements.txt
python populate.py
deactivate
cd ..
```

## Perform restore

```sh
./restore.sh
```

This doesn't reapply the terraform but does update the code. For a real project the updates should be commited and the CI/CD tooling ran to update everything. Any projects that use the dynamodb table should also be updated to use the new name. The old table should also be manually deleted

## Clean up

```sh
cd terraform

```