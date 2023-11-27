import mysql.connector
from libuser import user_create
import os
import boto3

def modify_public_access(db_instance_identifier, publicly_accessible, aws_region):
    rds_client = boto3.client('rds', region_name=aws_region)

    try:
        response = rds_client.modify_db_instance(
            DBInstanceIdentifier=db_instance_identifier,
            PubliclyAccessible=publicly_accessible,
            ApplyImmediately=True
        )
        print(f'Success: {response}')
    except Exception as e:
        print(f'Error: {e}')

# Database DB_CONFIGuration
DB_CONFIG = {
    'user': os.environ.get('AWS_DB_USER'),
    'password': os.environ.get('AWS_DB_PASSWORD'),
    'host': os.environ.get('AWS_DB_HOST'),
    'port': os.environ.get('AWS_DB_PORT'),
}


def database_exists(cursor, dbname):
    cursor.execute("SHOW DATABASES LIKE %s", (dbname,))
    return cursor.fetchone() is not None


def table_exists(cursor, tablename):
    cursor.execute("SHOW TABLES LIKE %s", (tablename,))
    return cursor.fetchone() is not None


def db_init_users():
    users = [
        ('admin', 'SuperSecret'),
        ('elliot', '123123123'),
        ('tim', '12345678')
    ]

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    if not database_exists(cursor, "db_users"):
        cursor.execute("CREATE DATABASE db_users")

    cursor.execute("USE db_users")

    if not table_exists(cursor, "users"):
        cursor.execute("""
            CREATE TABLE users (
                username TEXT, 
                password TEXT, 
                salt TEXT, 
                failures INT, 
                mfa_enabled INT, 
                mfa_secret TEXT
            )
        """)

    for u, p in users:
        # This function (user_create) might need to be modified based on your logic.
        user_create(u, p)

    cursor.close()
    conn.close()


def db_init_posts():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    if not database_exists(cursor, "db_posts"):
        cursor.execute("CREATE DATABASE db_posts")

    cursor.execute("USE db_posts")

    if not table_exists(cursor, "posts"):
        cursor.execute("""
            CREATE TABLE posts (
                date DATE, 
                username TEXT, 
                text TEXT
            )
        """)

    cursor.close()
    conn.close()


if __name__ == '__main__':
    db_init_users()
    db_init_posts()
    db_instance_identifier = os.environ.get('AWS_DB_ID')
    aws_region = os.environ.get('AWS_REGION')
    publicly_accessible = False  # Set to False to make the DB instance not publicly accessible
    modify_public_access(db_instance_identifier, publicly_accessible, aws_region)
