import random
import uuid
import boto3
from string import ascii_letters, digits

s = ascii_letters + digits
client = boto3.client("dynamodb", region_name="eu-west-1")
table_name = "testing-pitr"
user_ids = [str(uuid.uuid4()) for i in range(100)]

def generate_data():
    data = ''.join(random.choice(s) for i in range(200))
    id = uuid.uuid4()
    return (str(id), data)

def create_put_request(data):
    return {
        'PutRequest': {
            'Item': {
                'pitr-key': {
                    'S': data[0],
                },
                'data': {
                    'S': data[1],
                },
                'userid': {
                    'S': random.choice(user_ids)
                },
                'gsi-key': {
                    'S': str(uuid.uuid4())
                }
            },
        },
    }

def write_to_dynamo(data):
    requestData = [ create_put_request(d) for d in data]

    requestItems = {
        table_name: requestData
    }


    client.batch_write_item(RequestItems=requestItems)

def main():
    for x in range(2000):
        items = [ generate_data() for y in range(25)]
        write_to_dynamo(items)
        print(x)

if __name__ == "__main__":
    main()
