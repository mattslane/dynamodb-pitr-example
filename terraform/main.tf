resource "aws_dynamodb_table" "pitr-table" {
    name = "testing-pitr"
    hash_key = "pitr-key"

    write_capacity = var.write_capacity
    read_capacity = var.read_capacity

    attribute {
      name = "pitr-key"
      type = "S"
    }

    attribute {
        name = "gsi-key"
        type = "S"
    }


    point_in_time_recovery {
      enabled = true
    }

    global_secondary_index {
    name               = "GSIIndex"
    hash_key           = "gsi-key"
    range_key          = "pitr-key"
    write_capacity     = 200
    read_capacity      = 5
    projection_type    = "INCLUDE"
    non_key_attributes = ["pitr-key"]
  }

}