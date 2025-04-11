from flask import Flask, jsonify, request
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from config import Config
from models.user import Base, User
from flask_cors import CORS

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)


# * SQLAlchemy setup
engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'])
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(engine)

@app.route('/api/users',methods=['GET'])
def get_users():
    session = SessionLocal()
    try:
        users = session.query(User).all()
        data = [{'id':user.id,'name':user.name,'email':user.email} for user in users]
        return jsonify(data)
    finally:
        session.close()

@app.route('/api/users',methods=['POST'])
def create_user():
    session = SessionLocal()
    data = request.json
    try:
        new_user = User(name=data['name'],email = data['email'])
        session.add(new_user)
        session.commit()
        return jsonify({'message':'User created successfully!'}),201
    except Exception as e:
        session.rollback()
        return jsonify({'error':str(e)}),400
    finally:
        session.close()

if __name__ == '__main__':
    app.run(debug=True)