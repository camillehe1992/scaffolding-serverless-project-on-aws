#!/bin/bash
set -e -o pipefail
#########################################################################################################
#
# use public.ecr.aws/sam/build-python3.9 to install python packages in Linux environment to fix
# https://tg4.solutions/how-to-resolve-invalid-elf-header-error/
#
# it may spend a few minutes to download public.ecr.aws/sam/build-python3.9 to your local at the first time
#
#########################################################################################################
DIR=$(pwd)

REQUIREMENTS_DIR="$DIR/src/lambda_layers"
REQUIREMENTS_FILES=$(find $REQUIREMENTS_DIR -type f -name "requirements-*")

for FILE in $REQUIREMENTS_FILES; do
    FILE_NAME=$(basename -- "$FILE")
    TARGET="./build/${FILE_NAME%.*}"
    ZIP_FILE_NAME="${FILE_NAME%.*}.zip"
    echo "Installing packages from $FILE into $TARGET/python"

    pip3 install \
        --platform manylinux2014_x86_64 \
        --python 3.9 \
        --implementation cp \
        --only-binary=:all: --upgrade \
        --target "$TARGET/python" \
        -i https://pypi.tuna.tsinghua.edu.cn/simple \
        -r $FILE

    cd $TARGET
    zip -r $ZIP_FILE_NAME python
    mv $ZIP_FILE_NAME ../
    cd -

done

exit 0
