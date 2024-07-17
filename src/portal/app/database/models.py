import os
from pynamodb.models import Model
from pynamodb.attributes import UnicodeAttribute, BooleanAttribute

# Constants
ENVIRONMENT = os.getenv("ENVIRONMENT")
NICKNAME = os.getenv("NICKNAME", "todo")


class TodoModel(Model):
    """
    A DynamoDB Todo
    """

    class Meta:
        table_name = f"{ENVIRONMENT}-{NICKNAME}-todos"

    id = UnicodeAttribute(hash_key=True)
    userId = UnicodeAttribute(null=False)
    title = UnicodeAttribute(range_key=True)
    completed = BooleanAttribute(null=False)


class UserModel(Model):
    """
    A DynamoDB User
    """

    class Meta:
        table_name = f"{ENVIRONMENT}-{NICKNAME}-users"

    id = UnicodeAttribute(hash_key=True)
    email = UnicodeAttribute(range_key=True)
    username = UnicodeAttribute(null=True)
