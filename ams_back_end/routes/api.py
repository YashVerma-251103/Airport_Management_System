from flask import Blueprint, jsonify, request
from models.user import User
from database import SessionLocal

api_bp = Blueprint('api', __name__)

@api_bp.route('/users', methods=['GET'])
def get_users():
    session = SessionLocal()
    try:
        users = session.query(User).all()
        data = [{'id': user.id, 'name': user.name, 'email': user.email} for user in users]
        return jsonify(data)
    finally:
        session.close()

@api_bp.route('/users', methods=['POST'])
def create_user():
    session = SessionLocal()
    data = request.json
    try:
        new_user = User(name=data['name'], email=data['email'])
        session.add(new_user)
        session.commit()
        return jsonify({'message': 'User created successfully!'}), 201
    except Exception as e:
        session.rollback()
        return jsonify({'error': str(e)}), 400
    finally:
        session.close()
