# The python script is used to import the data from the JSON file to the DynamoDB table
# The JSON file should be in the same directory as the script
# The JSON file is coverted to the DynamoDB item format and saved in .build directory
# The script will clear the table before importing the data
# - todos.json - https://jsonplaceholder.typicode.com/todos
# - users.json - https://jsonplaceholder.typicode.com/users
# Usage: just import-ddb

import json
import uuid
import boto3  # type: ignore
from datetime import datetime, timezone


def clear_dynamodb_table(table_name):
    """Delete all items from a DynamoDB table"""
    try:
        dynamodb = boto3.resource("dynamodb")
        table = dynamodb.Table(table_name)

        # Get the table key schema to know the primary key
        table_info = boto3.client("dynamodb").describe_table(TableName=table_name)
        key_schema = table_info["Table"]["KeySchema"]

        # Extract primary key names
        partition_key = None
        sort_key = None

        for key in key_schema:
            if key["KeyType"] == "HASH":
                partition_key = key["AttributeName"]
            elif key["KeyType"] == "RANGE":
                sort_key = key["AttributeName"]

        print(
            f"Table {table_name} - Partition key: {partition_key}, Sort key: {sort_key}"
        )

        # Scan and delete all items
        deleted_count = 0

        # Use scan to get all items
        scan_kwargs = {"ProjectionExpression": partition_key}
        if sort_key:
            scan_kwargs["ProjectionExpression"] = f"{partition_key}, {sort_key}"

        while True:
            response = table.scan(**scan_kwargs)
            items = response.get("Items", [])

            if not items:
                break

            # Delete items in batches
            with table.batch_writer() as batch:
                for item in items:
                    # Create key dict for deletion
                    key_dict = {partition_key: item[partition_key]}
                    if sort_key and sort_key in item:
                        key_dict[sort_key] = item[sort_key]

                    batch.delete_item(Key=key_dict)
                    deleted_count += 1

            print(f"Deleted {deleted_count} items from {table_name} so far...")

            # Check for more items
            if "LastEvaluatedKey" in response:
                scan_kwargs["ExclusiveStartKey"] = response["LastEvaluatedKey"]
            else:
                break

        print(f"Successfully cleared {deleted_count} items from {table_name}")
        return deleted_count

    except Exception as e:
        print(f"Error clearing table {table_name}: {str(e)}")
        raise


def convert_users_data(users_data):
    """Convert users data by adding UUID and timestamps"""
    converted_users = []

    for user in users_data:
        # Create a new UUID for the user
        new_uuid = str(uuid.uuid4())

        # Store the original ID for mapping later (temporarily)
        original_id = user["id"]

        # Update the id field with UUID
        user["id"] = new_uuid

        # Remove unused fields
        if user.get("username"):
            del user["username"]
        if user.get("address"):
            del user["address"]

        # Add timestamps using timezone.utc
        current_time = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")
        user["created_at"] = current_time
        user["updated_at"] = current_time

        # Store the original ID in a temporary field for mapping
        user["_original_id"] = original_id

        converted_users.append(user)

    return converted_users


def convert_todos_data(todos_data, users_data):
    """Convert todos data by renaming userId, updating IDs, and adding timestamps"""
    # Create a mapping of original user IDs to new UUIDs
    user_id_mapping = {}
    for user in users_data:
        original_id = str(user["_original_id"])  # Get the original ID we stored
        new_uuid = user["id"]  # Get the new UUID
        user_id_mapping[original_id] = new_uuid
        print(
            f"Mapping original user ID {original_id} -> new UUID {new_uuid}"
        )  # Debug print

    converted_todos = []

    for todo in todos_data:
        # Create a new UUID for the todo
        new_uuid = str(uuid.uuid4())

        # Get the original user ID and convert to string
        original_user_id = str(todo["userId"])

        # Get the new user UUID from mapping
        new_user_uuid = user_id_mapping.get(original_user_id)

        if new_user_uuid is None:
            print(
                f"WARNING: Could not find mapping for original user ID: {original_user_id}"
            )
            # Generate a random UUID as fallback
            new_user_uuid = str(uuid.uuid4())

        # Rename userId to user_id and update the value
        todo["user_id"] = new_user_uuid
        del todo["userId"]

        # Update the id field with UUID
        todo["id"] = new_uuid

        # Add timestamps using timezone.utc
        current_time = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z")
        todo["created_at"] = current_time
        todo["updated_at"] = current_time

        converted_todos.append(todo)

    return converted_todos


def import_to_dynamodb(table_name, data):
    """Import data to DynamoDB table using batch writer"""
    try:
        # Remove temporary fields before importing
        cleaned_data = []
        for item in data:
            item_copy = item.copy()
            if "_original_id" in item_copy:
                del item_copy["_original_id"]
            cleaned_data.append(item_copy)

        # Import data
        print(f"\nImporting {len(cleaned_data)} items to {table_name}...")
        dynamodb = boto3.resource("dynamodb")
        table = dynamodb.Table(table_name)

        # Use batch writer (automatically handles the 25-item limit)
        with table.batch_writer() as batch:
            for item in cleaned_data:
                batch.put_item(Item=item)

        print(f"Successfully imported {len(cleaned_data)} items to {table_name}")
        return True

    except Exception as e:
        print(f"Error importing to {table_name}: {str(e)}")
        raise


def main():
    # File paths
    users_file = "data/users.json"
    todos_file = "data/todos.json"

    # Table names
    users_table = "dev-slstemplate-users"
    todos_table = "dev-slstemplate-todos"

    # Load the JSON data
    try:
        with open(users_file, "r") as f:
            users_data = json.load(f)
        print(f"Loaded {len(users_data)} users from {users_file}")

        with open(todos_file, "r") as f:
            todos_data = json.load(f)
        print(f"Loaded {len(todos_data)} todos from {todos_file}")
    except FileNotFoundError as e:
        print(f"Error loading file: {e}")
        return
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return

    # Print sample of original data for debugging
    print("\nSample original user data:")
    print(json.dumps(users_data[0] if users_data else {}, indent=2))
    print("\nSample original todo data:")
    print(json.dumps(todos_data[0] if todos_data else {}, indent=2))

    # Convert users data first
    print("\nConverting users data...")
    converted_users = convert_users_data(users_data)

    # Print sample of converted users
    print("\nSample converted user data:")
    sample_user = converted_users[0].copy()
    print(
        f"Original ID: {sample_user['_original_id']} -> New UUID: {sample_user['id']}"
    )

    # Convert todos data
    print("\nConverting todos data...")
    converted_todos = convert_todos_data(todos_data, converted_users)

    # Print sample of converted todos
    print("\nSample converted todo data:")
    sample_todo = converted_todos[0]
    print(f"Todo ID: {sample_todo['id']}")
    print(f"User ID: {sample_todo['user_id']}")

    # Save converted data to files
    clean_users = []
    for user in converted_users:
        user_clean = user.copy()
        del user_clean["_original_id"]
        clean_users.append(user_clean)

    with open(".build/converted_users.json", "w") as f:
        json.dump(clean_users, f, indent=2)

    with open(".build/converted_todos.json", "w") as f:
        json.dump(converted_todos, f, indent=2)

    print(
        "\nConverted data saved to .build/converted_users.json and .build/converted_todos.json"
    )

    # Import to DynamoDB
    print("\n" + "=" * 50)
    print("Starting DynamoDB import process")
    print("=" * 50)
    print(f"Target tables: {users_table} and {todos_table}")

    # Check if tables exist
    try:
        dynamodb = boto3.client("dynamodb")
        tables = dynamodb.list_tables()["TableNames"]

        if users_table not in tables:
            print(f"Error: Table {users_table} does not exist!")
            return
        else:
            print(f"Table {users_table} exists")

        if todos_table not in tables:
            print(f"Error: Table {todos_table} does not exist!")
            return
        else:
            print(f"Table {todos_table} exists")
    except Exception as e:
        print(f"Error verifying tables: {e}")
        return

    # Clear users table
    print("\n" + "-" * 30)
    print("Clearing users table...")
    clear_dynamodb_table(users_table)

    # Clear todos table
    print("\n" + "-" * 30)
    print("Clearing todos table...")
    clear_dynamodb_table(todos_table)

    # Import users
    print("\n" + "-" * 30)
    print("Importing to users table...")
    import_to_dynamodb(users_table, converted_users)

    # Import todos
    print("\n" + "-" * 30)
    print("Importing to todos table...")
    # import_to_dynamodb(todos_table, converted_todos)

    print("\n" + "=" * 50)
    print("Import completed successfully!")
    print("=" * 50)


if __name__ == "__main__":
    main()
