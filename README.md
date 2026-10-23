# Airflow

A single-container Apache Airflow 3.3.2 setup with one DAG (`my_simple_dag`). The DAG runs every minute and writes the current time to a PostgreSQL table.

## Configuration

Credentials are read from environment variables. Nothing is hard-coded in the image.

```bash
cp .env.example .env    # .env is git-ignored and excluded from the build context
# edit .env: set AIRFLOW_ADMIN_PASSWORD and POSTGRES_PASSWORD
```

| Variable | Purpose |
| --- | --- |
| `AIRFLOW_ADMIN_USERNAME`, `AIRFLOW_ADMIN_PASSWORD` | Admin UI login, created on startup (required) |
| `AIRFLOW_ADMIN_EMAIL`, `AIRFLOW_ADMIN_FIRSTNAME`, `AIRFLOW_ADMIN_LASTNAME` | Optional admin profile fields |
| `POSTGRES_HOST`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` | Target database for the DAG task |

## Run

```bash
docker build -t my-airflow .
docker run --env-file .env -p 8080:8080 my-airflow
```

Then open http://localhost:8080 and log in with the admin credentials from `.env`.

To upgrade Airflow, change the pinned `apache/airflow` tag in the `Dockerfile`. Avoid `:latest`.
