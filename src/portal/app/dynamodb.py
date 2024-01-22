from pynamodb.models import Model
from pynamodb.attributes import UnicodeAttribute


class UserModel(Model):
    """
    A DynamoDB User
    """

    class Meta:
        table_name = "dynamodb-user"

    id = UnicodeAttribute(null=True)
    title = UnicodeAttribute(range_key=True)
    last_name = UnicodeAttribute(hash_key=True)


if __name__ == "__main__":
    UserModel.create_table(read_capacity_units=1, write_capacity_units=1)
