import dlib
import cv2
import numpy as np
import firebase_admin
from firebase_admin import credentials, db

cred = credentials.Certificate("firebase/cameye-5f664-c3567a4e5c2b.json")
firebase_admin.initialize_app(cred, {'databaseURL': 'https://your-database-url.firebaseio.com'})

detector = dlib.get_frontal_face_detector()
shape_predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')
face_recognizer = dlib.face_recognition_model_v1('dlib_face_recognition_resnet_model_v1.dat_2')

def get_authorized_users():
    ref = db.reference("/authorized_users")
    users = ref.get()
    return users

def compare_faces(known_encodings, face_encoding):
    return np.linalg.norm(known_encodings - face_encoding) < 0.6

def process_intrusion(frame):
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = detector(gray)
    
    authorized_users = get_authorized_users()

    for face in faces:
        shape = shape_predictor(gray, face)
        face_encoding = np.array(face_recognizer.compute_face_descriptor(frame, shape))

        authorized = False
        for user_id, user_data in authorized_users.items():
            known_encoding = np.array(user_data["encoding"])
            if compare_faces(known_encoding, face_encoding):
                print(f"Authorized user {user_data['name']} detected.")
                authorized = True
                # Log this entry as authorized
                log_entry(user_data['name'], 'authorized', frame)
                break

        if not authorized:
            print("Unauthorized user detected!")
            # Log this entry as unauthorized and trigger an alert
            log_entry("Unknown", 'unauthorized', frame)
            send_intrusion_alert()

def log_entry(name, status, frame):
    ref = db.reference("/entries")
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    entry_data = {
        "name": name,
        "status": status,
        "timestamp": timestamp,
        "image": save_image(frame)  # Store the image path in Firebase
    }
    ref.push(entry_data)

def save_image(frame):
    # Save frame as an image and return the file path
    filename = f"images/{time.time()}.jpg"
    cv2.imwrite(filename, frame)
    return filename
