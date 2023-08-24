from enum import Enum


class ResponseMessage(Enum):
    SUCCESS = "success"
    FAILED = "failed"


class LOG_LEVEL(Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARNING"
    ERROR = "ERROR"


class Environment(Enum):
    LOCAL = "local"
    DEVELOPMENT = "dev"
    TEST = "test"
    PRODUCTION = "prod"
