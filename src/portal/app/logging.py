# We prioritise log level settings in this order:
#
# 1. AWS_LAMBDA_LOG_LEVEL environment variable
# 2. Explicit log level in Logger constructor, or by calling the logger.setLevel() method
# 3. POWERTOOLS_LOG_LEVEL environment variable

from aws_lambda_powertools.logging import Logger

logger = Logger()
