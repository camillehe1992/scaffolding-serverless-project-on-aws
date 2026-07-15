"""
Centralized application configuration.
All environment variables and hard-coded values should be defined here.
"""

import os
from typing import Optional

# --------------------------------------------------------------------------- #
# Environment helpers
# --------------------------------------------------------------------------- #


def _getenv(key: str, default: Optional[str] = None) -> str:
    """
    Return an environment variable value or raise if not set and no default.
    """
    value = os.getenv(key, default)
    if value is None:
        raise RuntimeError(f"Environment variable {key} is required but not set")
    return value


def _getenv_bool(key: str, default: str = "false") -> bool:
    """
    Return an environment variable as a boolean.
    """
    return _getenv(key, default).lower() in {"true", "1", "yes", "on"}


# --------------------------------------------------------------------------- #
# Application metadata
# --------------------------------------------------------------------------- #

APP_VERSION: str = _getenv("APP_VERSION", "1.0.0").replace("\n", "")
ENVIRONMENT: str = _getenv("ENVIRONMENT", "dev")
APPLICATION_NAME: str = _getenv("APPLICATION_NAME", "sls-template")

# --------------------------------------------------------------------------- #
# Observability
# --------------------------------------------------------------------------- #

LOG_LEVEL: str = _getenv("LOG_LEVEL", "INFO")
POWERTOOLS_LOG_LEVEL: str = _getenv("POWERTOOLS_LOG_LEVEL", LOG_LEVEL)
POWERTOOLS_SERVICE_NAME: str = _getenv("POWERTOOLS_SERVICE_NAME", APPLICATION_NAME)

# --------------------------------------------------------------------------- #
# AWS configuration
# --------------------------------------------------------------------------- #

AWS_REGION: str = _getenv("AWS_REGION", "ap-southeast-1")

# --------------------------------------------------------------------------- #
# DynamoDB
# --------------------------------------------------------------------------- #

# Table names are built from environment and nickname to allow multi-tenant deployments
TODOS_TABLE_NAME: str = _getenv(
    "TODOS_TABLE_NAME", f"{ENVIRONMENT}-{APPLICATION_NAME}-todos"
)
USERS_TABLE_NAME: str = _getenv(
    "USERS_TABLE_NAME", f"{ENVIRONMENT}-{APPLICATION_NAME}-users"
)

# --------------------------------------------------------------------------- #
# API Gateway
# --------------------------------------------------------------------------- #

# Placeholder for future API-specific settings
API_CORS_ORIGIN: str = _getenv("API_CORS_ORIGIN", "*")

# --------------------------------------------------------------------------- #
# Feature flags
# --------------------------------------------------------------------------- #

# Example: enable detailed tracing
ENABLE_TRACING: bool = _getenv_bool("ENABLE_TRACING", "false")

# --------------------------------------------------------------------------- #
# Config class exposing all settings
# --------------------------------------------------------------------------- #


class Config:
    """Centralized configuration accessor for the application."""

    app_version = APP_VERSION
    environment = ENVIRONMENT
    application_name = APPLICATION_NAME
    log_level = LOG_LEVEL
    powertools_log_level = POWERTOOLS_LOG_LEVEL
    powertools_service_name = POWERTOOLS_SERVICE_NAME
    aws_region = AWS_REGION
    todos_table_name = TODOS_TABLE_NAME
    users_table_name = USERS_TABLE_NAME
    api_cors_origin = API_CORS_ORIGIN
    enable_tracing = ENABLE_TRACING

    # Allow dict-style access for backward compatibility
    def __getitem__(self, item):
        return getattr(self, item)

    # Allow iteration over keys
    def __iter__(self):
        return iter(self.__dict__)

    # Allow membership checks
    def __contains__(self, item):
        return hasattr(self, item)

    # String representation for debugging
    def __repr__(self):
        return f"<Config {self.__dict__}>"


# Singleton instance for import convenience
config = Config()
