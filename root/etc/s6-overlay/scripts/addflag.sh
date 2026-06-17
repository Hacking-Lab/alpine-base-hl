#!/command/with-contenv bash

set -euo pipefail

shopt -s nullglob
GN_FILES=(/goldnugget/*.gn)

DEPLOY_FILE=/flag-deploy-scripts/deploy-file-flag.sh
DEPLOY_ENV=/flag-deploy-scripts/deploy-env-flag.sh

if [ "${#GN_FILES[@]}" -gt 1 ]; then
      echo "Expected at most one /goldnugget/*.gn file, found ${#GN_FILES[@]}." >&2
      exit 1
fi

if [ "${#GN_FILES[@]}" -eq 1 ]; then
      GN_FILE=${GN_FILES[0]}
      export GN_FILE
      echo "Goldnugget found in file $GN_FILE."

      if [ -z "${GOLDNUGGET:-}" ]
      then
            echo "Setting \$GOLDNUGGET from file"
            # shellcheck disable=SC1090
            source "$GN_FILE"
      fi

      chown root:root /goldnugget
      chmod 700 /goldnugget
      ls -lA /goldnugget

      echo "Overwrite $DEPLOY_FILE to define what to do with the flag file."

      if [ -f "$DEPLOY_FILE" ]
      then
            echo "Running $DEPLOY_FILE..."
            bash "$DEPLOY_FILE"
      else
            echo "Script $DEPLOY_FILE not found."
      fi
fi

if [ -z "${GOLDNUGGET:-}" ]
then
      echo "No dynamic flag in environment variable \$GOLDNUGGET."
else
      echo "Goldnugget found in environment."
      echo "Overwrite $DEPLOY_ENV to define what to do with the flag file."

      if [ -f "$DEPLOY_ENV" ]
      then
            echo "Running $DEPLOY_ENV..."
            bash "$DEPLOY_ENV"
      else
            echo "Script $DEPLOY_ENV not found."
      fi

      unset GOLDNUGGET
      export GOLDNUGGET
fi
