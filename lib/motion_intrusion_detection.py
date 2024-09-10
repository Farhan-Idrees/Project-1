import cv2
import time

class MotionDetector:
    def __init__(self, sensitivity=500):
        self.first_frame = None
        self.sensitivity = sensitivity

    def detect_motion(self, frame):
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gray = cv2.GaussianBlur(gray, (21, 21), 0)
        if self.first_frame is None:
            self.first_frame = gray
            return None, None

        frame_delta = cv2.absdiff(self.first_frame, gray)
        thresh = cv2.threshold(frame_delta, 25, 255, cv2.THRESH_BINARY)[1]
        thresh = cv2.dilate(thresh, None, iterations=2)
        contours, _ = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        motion_detected = False
        for contour in contours:
            if cv2.contourArea(contour) < self.sensitivity:
                continue
            motion_detected = True
            (x, y, w, h) = cv2.boundingRect(contour)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

        return frame, motion_detected

def process_motion_detection():
    motion_detector = MotionDetector()
    camera = cv2.VideoCapture(0)

    while True:
        ret, frame = camera.read()
        if not ret:
            break
        processed_frame, motion_detected = motion_detector.detect_motion(frame)
        
        if motion_detected:
            print("Motion detected. Triggering intrusion detection.")
            # Pass this to the intrusion detection and recognition module
            # intrusion_recognition.process_intrusion(frame)
        
        cv2.imshow("Security Feed", processed_frame)
        key = cv2.waitKey(1) & 0xFF

        if key == ord('q'):
            break

    camera.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    process_motion_detection()
