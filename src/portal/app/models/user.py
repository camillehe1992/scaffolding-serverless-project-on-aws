from datetime import datetime
import uuid
from pydantic import BaseModel, Field


class Company(BaseModel):
    """
    Company map attribute
    """

    name: str = Field(description="User company name", example="Romaguera-Crona")
    catchPhrase: str = Field(
        description="User company catch phrase",
        example="Multi-layered client-server neural-net",
    )
    bs: str = Field(
        description="User company business model", example="harness real-time e-markets"
    )


class UserCreated(BaseModel):
    email: str = Field(description="User email", example="Sincere@april.biz")
    name: str = Field(description="User name", example="Leanne Graham")


class UserUpdated(BaseModel):
    name: str = Field(description="User name", example="Leanne Graham")
    phone: str = Field(
        description="User phone", example="1-770-736-8031 x56442", nullable=True
    )
    website: str = Field(
        description="User website", example="hildegard.org", nullable=True
    )
    company: Company = Field(description="User company", nullable=True)


class User(BaseModel):
    id_: str = Field(
        alias="id",
        default_factory=lambda: str(uuid.uuid4()),
        examples=["bfc7adb5-fd97-473d-a10f-29cf8b48811d"],
    )
    email: str = Field(
        description="User email", example="Sincere@april.biz", nullable=False
    )
    name: str = Field(description="User name", example="Leanne Graham", nullable=False)
    phone: str = Field(
        description="User phone", example="1-770-736-8031 x56442", nullable=True
    )
    website: str = Field(
        description="User website", example="hildegard.org", nullable=True
    )
    company: Company = Field(description="User company", nullable=True)
    created_at: datetime = Field(
        description="User created datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
        nullable=True,
    )
    updated_at: datetime = Field(
        description="User updated datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
        nullable=True,
    )
