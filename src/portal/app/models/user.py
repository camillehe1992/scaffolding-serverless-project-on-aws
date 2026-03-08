from datetime import datetime
from uuid import uuid4
from pydantic import BaseModel, Field


class Geo(BaseModel):
    lat: str = Field(description="User latitude", example="37.7749")
    lng: str = Field(description="User longitude", example="-122.4194")


class Address(BaseModel):
    street: str = Field(description="User street address", example="Kulas Light")
    suite: str = Field(description="User suite address", example="Apt. 556")
    city: str = Field(description="User city", example="Gwenborough")
    zipcode: str = Field(description="User zipcode", example="92998-3874")
    geo: Geo = Field(description="User geographic coordinates")


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


class User(BaseModel):
    id_: str = Field(
        alias="id",
        default_factory=lambda: uuid4().hex,
        examples=["bfc7adb5-fd97-473d-a10f-29cf8b48811d"],
    )
    name: str = Field(description="User name", example="Leanne Graham")
    username: str = Field(description="User username", example="Bret")
    email: str = Field(description="User email", example="Sincere@april.biz")
    address: Address = Field(description="User address")
    phone: str = Field(description="User phone", example="1-770-736-8031 x56442")
    website: str = Field(description="User website", example="hildegard.org")
    company: Company = Field(description="User company")
    created_at: datetime = Field(
        description="User created datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
    )
    updated_at: datetime = Field(
        description="User updated datetime",
        default_factory=datetime.now,
        example="2023-01-01T00:00:00Z",
    )
