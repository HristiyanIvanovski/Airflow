import os
import warnings
from datetime import datetime
from airflow.sdk import DAG
from airflow.providers.standard.operators.python import PythonOperator
import psycopg2

warnings.filterwarnings("ignore", category=DeprecationWarning)


def print_time_only(**kwargs):
    now = datetime.now()
    formatted_time = now.strftime('%Y.%m.%d %H:%M:%S')
    print(f'Current Time: {formatted_time}')

    # Connect to the PostgreSQL server
    conn = psycopg2.connect(
        host=os.environ.get("POSTGRES_HOST", "localhost"),
        database=os.environ.get("POSTGRES_DB", "afdagtasktimedb"),
        user=os.environ.get("POSTGRES_USER", "postgres"),
        password=os.environ["POSTGRES_PASSWORD"],
    )

    # Create a cursor object
    cur = conn.cursor()

    # Insert data into the table
    cur.execute("INSERT INTO afdagtasktimedb (time) VALUES (%s)",
                (formatted_time,))

    # Commit changes
    conn.commit()

    # Close cursor and connection
    cur.close()
    conn.close()


default_args = {
    'owner': 'airflow',
    'start_date': datetime(2022, 1, 1)
}

dag = DAG(
    dag_id='my_simple_dag',
    default_args=default_args,
    schedule='*/1 * * * *',  # Run every minute
)

task = PythonOperator(
    task_id='print_time_only',
    python_callable=print_time_only,
    dag=dag,
)
