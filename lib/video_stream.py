import cv2
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from typing import List

app = FastAPI()

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, data: bytes):
        for connection in self.active_connections:
            await connection.send_bytes(data)

manager = ConnectionManager()

@app.websocket("/video_feed")
async def video_feed(websocket: WebSocket):
    await manager.connect(websocket)
    camera = cv2.VideoCapture(0)  # Or provide IP camera URL here
    try:
        while True:
            success, frame = camera.read()
            if not success:
                break
            ret, buffer = cv2.imencode('.jpg', frame)
            await manager.broadcast(buffer.tobytes())
    except WebSocketDisconnect:
        manager.disconnect(websocket)
    finally:
        camera.release()
