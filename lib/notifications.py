import firebase_admin
from firebase_admin import messaging

def send_intrusion_alert():
    message = messaging.Message(
        notification=messaging.Notification(
            title="Unauthorized Access Detected",
            body="An intrusion was detected at your premises.",
        ),
        topic="admin_alerts",
    )
    response = messaging.send(message)
    print('Notification sent:', response)
