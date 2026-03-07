from enum import Enum


class ResponseMessage(Enum):
    """Response message enum"""

    SUCCESS = "success"
    FAILED = "failed"


class LOG_LEVEL(Enum):
    """Log level enum"""

    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARNING"
    ERROR = "ERROR"


class Environment(Enum):
    """Environment enum"""

    LOCAL = "local"
    DEVELOPMENT = "dev"
    PRODUCTION = "prod"


class BooleanStr(str, Enum):
    """Boolean string enum"""

    TRUE = "true"
    FALSE = "false"
