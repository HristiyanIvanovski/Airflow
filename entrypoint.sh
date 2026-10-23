#!/bin/bash
set -euo pipefail

: "${AIRFLOW_ADMIN_USERNAME:?Set AIRFLOW_ADMIN_USERNAME (see .env.example)}"
: "${AIRFLOW_ADMIN_PASSWORD:?Set AIRFLOW_ADMIN_PASSWORD (see .env.example)}"

airflow db migrate

airflow users create \
    --username "$AIRFLOW_ADMIN_USERNAME" \
    --password "$AIRFLOW_ADMIN_PASSWORD" \
    --firstname "${AIRFLOW_ADMIN_FIRSTNAME:-Airflow}" \
    --lastname "${AIRFLOW_ADMIN_LASTNAME:-Admin}" \
    --role Admin \
    --email "${AIRFLOW_ADMIN_EMAIL:-admin@example.com}" \
    || echo "Admin user not created (it may already exist)"

airflow scheduler &
airflow dag-processor &
exec airflow api-server
