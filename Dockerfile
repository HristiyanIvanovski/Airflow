FROM apache/airflow:3.3.2

# Admin credentials are supplied at runtime (see .env.example), never baked into the image.
ENV AIRFLOW__CORE__AUTH_MANAGER=airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager

# Copy the DAG script to the DAGs folder in the container
COPY airflow_dag_task.py /opt/airflow/dags/

# Copy the Airflow configuration
COPY airflow.cfg /opt/airflow/airflow.cfg

# Adding entrypoint script and setting permissions
COPY entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh && chown airflow: /entrypoint.sh
USER airflow
# Bundled certifi/pip/uv in the 3.3.2 image still trust the compromised emSign CA (GHSA-6q48-6c7w-9gw2, GHSA-hq85-5cpj-mr62)
RUN pip install --no-cache-dir "apache-airflow==3.3.2" "certifi>=2026.10.19" "pip>=26.2.2" "uv>=0.13.4"
ENTRYPOINT ["/entrypoint.sh"]
