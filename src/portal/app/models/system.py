# pylint: disable=no-name-in-module
from datetime import datetime, timezone
from pydantic import BaseModel, Field


class SystemInfo(BaseModel):
    version: str = Field(default="1.0.0", description="Application version")
    service: str = Field(default="slstemplate", description="Application service")
    application_name: str = Field(default="slstemplate", description="Application name")
    environment: str = Field(default="dev", description="Application environment")
    current_datetime: datetime = Field(
        default=datetime.now(timezone.utc), description="Current datetime"
    )
