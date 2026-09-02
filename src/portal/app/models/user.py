from datetime import datetime, timezone
import uuid
from pydantic import BaseModel, Field


class Company(BaseModel):
    """
    Company map attribute
    """

    name: str = Field(description="User company name", examples=["Romaguera-Crona"])
    catchPhrase: str = Field(
        description="User company catch phrase",
        examples=["Multi-layered client-server neural-net"],
    )
    bs: str = Field(
        description="User company business model",
        examples=["harness real-time e-markets"],
    )


class UserCreated(BaseModel):
    email: str = Field(description="User email", examples=["Sincere@april.biz"])
    name: str = Field(description="User name", examples=["Leanne Graham"])


class UserUpdated(BaseModel):
    name: str = Field(description="User name", examples=["Leanne Graham"])
    phone: str | None = Field(
        description="User phone", examples=["1-770-736-8031 x56442"]
    )
    website: str | None = Field(description="User website", examples=["hildegard.org"])
    company: Company | None = Field(description="User company")


class User(BaseModel):
    id_: str = Field(
        alias="id",
        default_factory=lambda: str(uuid.uuid4()),
        examples=["bfc7adb5-fd97-473d-a10f-29cf8b48811d"],
    )
    email: str = Field(description="User email", examples=["Sincere@april.biz"])
    name: str = Field(description="User name", examples=["Leanne Graham"])
    phone: str | None = Field(
        description="User phone", examples=["1-770-736-8031 x56442"]
    )
    website: str | None = Field(description="User website", examples=["hildegard.org"])
    company: Company | None = Field(description="User company")
    created_at: datetime | None = Field(
        description="User created datetime",
        default_factory=lambda: datetime.now(timezone.utc),
        examples=["2023-01-01T00:00:00Z"],
    )
    updated_at: datetime | None = Field(
        description="User updated datetime",
        default_factory=lambda: datetime.now(timezone.utc),
        examples=["2023-01-01T00:00:00Z"],
    )
