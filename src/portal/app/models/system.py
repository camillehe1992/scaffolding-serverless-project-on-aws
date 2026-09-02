from datetime import datetime, timezone
from pydantic import BaseModel, Field


class SystemInfo(BaseModel):
    version: str = Field(default="0.0.1", description="Application version")
    service: str = Field(default="sls-template", description="Application service")
    application_name: str = Field(default="sls-template", description="Application name")
    environment: str = Field(default="dev", description="Application environment")
    current_datetime: datetime = Field(
        default=datetime.now(timezone.utc),
        description="Current datetime",
        examples=["2023-01-01T00:00:00Z"],
    )
