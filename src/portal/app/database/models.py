import os
from pynamodb.models import Model
from pynamodb.attributes import UnicodeAttribute, BooleanAttribute, MapAttribute

# Constants
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")
APPLICATION_NAME = os.getenv("APPLICATION_NAME", "slstemplate")


class TodoModel(Model):
    """
    A DynamoDB Table for the application to store todos
    """

    class Meta:
        table_name = f"{ENVIRONMENT}-{APPLICATION_NAME}-todos"

    id = UnicodeAttribute(hash_key=True)
    user_id = UnicodeAttribute(null=False)
    title = UnicodeAttribute(range_key=True)
    completed = BooleanAttribute(null=False)
    created_at = UnicodeAttribute(null=False)
    updated_at = UnicodeAttribute(null=False)


class Geo(MapAttribute):
    """
    Geo map attribute
    """

    lat = UnicodeAttribute(null=False)
    lng = UnicodeAttribute(null=False)


class Address(MapAttribute):
    """
    Address map attribute
    """

    street = UnicodeAttribute(null=False)
    suite = UnicodeAttribute(null=False)
    city = UnicodeAttribute(null=False)
    zipcode = UnicodeAttribute(null=False)
    geo = Geo(null=False)


class Company(MapAttribute):
    """
    Company map attribute
    """

    name = UnicodeAttribute(null=False)
    catchPhrase = UnicodeAttribute(null=False)
    bs = UnicodeAttribute(null=False)


class UserModel(Model):
    """
    A DynamoDB Table for the application to store users
    """

    class Meta:
        table_name = f"{ENVIRONMENT}-{APPLICATION_NAME}-users"

    id = UnicodeAttribute(hash_key=True)
    name = UnicodeAttribute(null=True)
    email = UnicodeAttribute(range_key=True)
    username = UnicodeAttribute(null=False)
    address = Address(null=False)
    phone = UnicodeAttribute(null=False)
    website = UnicodeAttribute(null=False)
    company = Company(null=False)
