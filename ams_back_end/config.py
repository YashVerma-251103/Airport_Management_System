import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL','postgresql+psycopg2://username:password@localhost/mydatabase'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False