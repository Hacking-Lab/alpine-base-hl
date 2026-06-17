#!/command/with-contenv bash

set -euo pipefail

shopt -s nullglob
GN_FILES=(/goldnugget/*.gn)

DEPLOY_FILE=/flag-deploy-scripts/deploy-file-flag.sh
DEPLOY_ENV=/flag-deploy-scripts/deploy-env-flag.sh
GOLDNUGGET_FROM_FILE=0

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
            GOLDNUGGET_FROM_FILE=1
      fi

      chown root:root /goldnugget || echo "Warning: could not chown /goldnugget; continuing."
      chmod 700 /goldnugget || echo "Warning: could not chmod /goldnugget; continuing."
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

if [ -z "${GOLDNUGGET:-}" ] || [ "$GOLDNUGGET_FROM_FILE" -eq 1 ]
then
      if [ "$GOLDNUGGET_FROM_FILE" -eq 0 ]; then
            echo "No dynamic flag in environment variable \$GOLDNUGGET."
      fi
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
