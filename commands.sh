#!/bin/bash
set -e

PROJECT_ID="your_gcp_project"
REGION="southamerica-east1"

# https://docs.cloud.google.com/bigquery/docs/locations


# https://docs.cloud.google.com/dataform/docs/use-dataform-cli?hl=pt-br

npm i -g @dataform/cli@^3.0.0-beta

dataform init . ${PROJECT_ID} ${REGION}