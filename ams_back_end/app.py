import os
from flask import Flask, jsonify, request
from sqlalchemy.orm import sessionmaker
from config import Config, DevelopmentConfig, ProductionConfig
from models.user import Base, User
from flask_cors import CORS
from routes.api import api_bp  # blueprint import

# * Load configuration
db_uri = os.environ.get("DATABASE_URL")
print("DATABASE_URL:", db_uri)  # Should print your connection string

app = Flask(__name__)
# app.config.from_object(Config)
app.config.from_object(DevelopmentConfig)
CORS(app)

# * Import database setup
from database import engine, SessionLocal

Base.metadata.create_all(engine)

# * Register blueprint
app.register_blueprint(api_bp, url_prefix='/api')

if __name__ == '__main__':
    app.run(debug=True)
