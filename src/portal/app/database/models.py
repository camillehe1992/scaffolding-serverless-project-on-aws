from datetime import datetime, timezone
import uuid
from pynamodb.models import Model
from pynamodb.attributes import UnicodeAttribute, BooleanAttribute, MapAttribute
from app.settings import Config


class TodoModel(Model):
    """
    A DynamoDB Table for the application to store todos
    """

    class Meta:
        table_name = Config.todos_table_name

    id = UnicodeAttribute(hash_key=True)
    user_id = UnicodeAttribute(null=True)
    title = UnicodeAttribute(range_key=True)
    completed = BooleanAttribute(null=False, default=False)
    created_at = UnicodeAttribute(null=False, default="")
    updated_at = UnicodeAttribute(null=False, default="")


class Company(MapAttribute):
    """
    Company map attribute
    """

    name = UnicodeAttribute(null=False, default="")
    catchPhrase = UnicodeAttribute(null=False, default="")
    bs = UnicodeAttribute(null=False, default="")


class UserModel(Model):
    """
    A DynamoDB Table for the application to store users
    """

    class Meta:
        table_name = Config.users_table_name

    id = UnicodeAttribute(hash_key=True, default_for_new=lambda: uuid.uuid4().hex)
    email = UnicodeAttribute(null=True, range_key=True)
    name = UnicodeAttribute(null=True)
    phone = UnicodeAttribute(null=False, default="")
    website = UnicodeAttribute(null=False, default="")
    company = Company(null=False, default=dict)
    created_at = UnicodeAttribute(
        null=False,
        default_for_new=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z"),
    )
    updated_at = UnicodeAttribute(
        null=False,
        default_for_new=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.000Z"),
    )
