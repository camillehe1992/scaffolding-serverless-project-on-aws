from os import environ as env
from aws_lambda_powertools.logging import Logger

logger = Logger(env.get("LOG_LEVEL", "DEBUG"))
