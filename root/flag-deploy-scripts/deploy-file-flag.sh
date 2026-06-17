#!/command/with-contenv bash

set -euo pipefail

echo "put your commands to deploy the file based flag here"
echo "the /goldnugget/*.gn contains the flag"

if [ -z "${GN_FILE:-}" ]; then
    echo "\$GN_FILE not set. The addflag service should set it before running this script." >&2
    exit 1
fi

# shellcheck disable=SC1090
source "$GN_FILE"

echo "extend this script and move the dynamic flag to the destination you want"
