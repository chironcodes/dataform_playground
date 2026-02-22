#!/bin/bash
set -e

# Load .env if it exists
if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

: "${PROJECT_ID:?PROJECT_ID is not set. Define it in .env or the environment}"
: "${REGION:?REGION is not set. Define it in .env or the environment}"

# https://docs.cloud.google.com/bigquery/docs/locations


# https://docs.cloud.google.com/dataform/docs/use-dataform-cli?hl=pt-br

npm i -g @dataform/cli@^3.0.0-beta

dataform init . ${PROJECT_ID} ${REGION}

dataform init-creds