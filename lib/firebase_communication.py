import firebase_admin
from firebase_admin import credentials, db

cred = credentials.Certificate("firebase/cameye-5f664-c3567a4e5c2b.json")
firebase_admin.initialize_app(cred, {'databaseURL': 'https://your-database-url.firebaseio.com'})

# Function to add camera details
def add_camera(camera_id, camera_data):
    ref = db.reference("/cameras")
    ref.child(camera_id).set(camera_data)

# Function to get camera details
def get_cameras():
    ref = db.reference("/cameras")
    return ref.get()

# Function to add authorized users
def add_authorized_user(user_id, user_data):
    ref = db.reference("/authorized_users")
    ref.child(user_id).set(user_data)

# Function to get authorized users
def get_authorized_users():
    ref = db.reference("/authorized_users")
    return ref.get()
