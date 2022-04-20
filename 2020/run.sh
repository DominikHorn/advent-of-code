#!/bin/bash

EXEC_NAME=program
FRAGMENT=frag.json
COMPILE_DB=compile_commands.json

# Compile program
clang++ --std=c++20 -MJ "${FRAGMENT}" -O0 -g -fsanitize=address,undefined $1 -o "${EXEC_NAME}"

# Build compilation database
sed -e '1s/^/[\'$'\n''/' -e '$s/,$/\'$'\n'']/' "${FRAGMENT}" > "${COMPILE_DB}"
rm ${FRAGMENT}

# Execute and retain result
./"${EXEC_NAME}" ${@:2}
EXIT_CODE=$?

# Cleanup generated files
rm -rf "${EXEC_NAME}.dSYM"
rm "${EXEC_NAME}"

# Propagate exit code
exit ${EXIT_CODE}
