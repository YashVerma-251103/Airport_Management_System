import os
from dotenv import load_dotenv
load_dotenv()


class Config:
    # SECRET_KEY = os.environ.get("SECRET_KEY") or "you-will-never-guess"
    # SQLALCHEMY_DATABASE_URI = os.getenv(
    #     'DATABASE_URL','postgresql+psycopg2://username:password@localhost/mydatabase'
    # )
    SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")

    SQLALCHEMY_TRACK_MODIFICATIONS = False


class DevelopmentConfig(Config):
    DEBUG = True

class ProductionConfig(Config):
    DEBUG = False
    # Configure production-level settings